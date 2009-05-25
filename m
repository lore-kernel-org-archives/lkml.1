Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZEYLpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZEYLpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZEYLpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:45:35 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:45585 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZEYLpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:45:35 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905242154560.15195-100000@netrider.rowland.org>
References: <1243178448.4035.12.camel@poy> <Pine.LNX.4.44L0.0905242154560.15195-100000@netrider.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 25 May 2009 13:45:14 +0200
Message-ID: <ac3eb2510905250445p60035f92k68c29a57039223cf@mail.gmail.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
	directories.
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 04:06, Alan Stern <stern@rowland.harvard.edu> wrote:

> This looks like a bug I found almost two weeks ago.  The bug was
> introduced by Arjan as part of his async conversion (the async routine
> runs without acquiring one of the mutexes held by its caller).  The
> result is a race in the sd driver -- no connection with USB,

Ah, I see.

> by the way -- so it's a little difficult to trigger.

I can trigger it pretty reliable now on plain -rc7 , but only with
more hubs in-between the storage device. It usually take less than
10-15 connect/disconnect cycles.

It looks like a serious bug though, after the bug triggered, random,
likely unrelated, applications crash, and I can not cleanly shot down
anymore.

> I posted a patch, but the
> reporter never said whether or not the patch fixed the problem.  Hence
> the patch hasn't been submitted.
>
> Here it is for you to try out.

I'll give it try now.

Kay
