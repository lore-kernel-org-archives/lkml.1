Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZEZQ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZEZQ2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZEZQ1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:27:40 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:44730 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZEZQ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905250445p60035f92k68c29a57039223cf@mail.gmail.com>
References: <1243178448.4035.12.camel@poy> <Pine.LNX.4.44L0.0905242154560.15195-100000@netrider.rowland.org> 
	<ac3eb2510905250445p60035f92k68c29a57039223cf@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 26 May 2009 18:27:19 +0200
Message-ID: <ac3eb2510905260927we3c748akbbcaf3f3ac1da096@mail.gmail.com>
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
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 13:45, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Mon, May 25, 2009 at 04:06, Alan Stern <stern@rowland.harvard.edu> wrote:

>> by the way -- so it's a little difficult to trigger.
>
> I can trigger it pretty reliable now on plain -rc7 , but only with
> more hubs in-between the storage device. It usually take less than
> 10-15 connect/disconnect cycles.
>
> It looks like a serious bug though, after the bug triggered, random,
> likely unrelated, applications crash, and I can not cleanly shot down
> anymore.

Just a heads up if anybody is trying to reproduce this, it trashed my
ext3 rootfs, which is not recoverable.

Not sure what exactly caused this, but I didn't have anything like
this for a very long time.

I tried to reproduce the issue a few times more, and it crashed random
processes after the bug triggered, like mentioned above, and the box
never shut down cleanly.

It's entirely possible, that bug causes serious issues.

Thanks,
Kay
