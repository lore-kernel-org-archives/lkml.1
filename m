Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbXHGOVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbXHGOVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbXHGOVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:21:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37800 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbXHGOVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:21:24 -0400
Message-ID: <46B87FDE.3050309@garzik.org>
Date: Tue, 07 Aug 2007 10:21:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: akpm@linux-foundation.org, James.Bottomley@SteelEye.com,
       torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>	<1186458941.6637.44.camel@localhost.localdomain>	<20070807001429.f8cb3b22.akpm@linux-foundation.org> <20070806162823P.tomof@acm.org>
In-Reply-To: <20070806162823P.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 7 Aug 2007 00:14:29 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Mon, 06 Aug 2007 22:55:41 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
>>
>>> The real root cause of all of this is that there's no tree I can
>>> persuade all the interested parties to test that includes all of these
>>> features.  In spite of the fact they've all been incubating in -mm for
>>> at least 3 months, no-one apparently tested all the features together
>>> until 2.6.23-rc1 was released, so then we're scrambling to address the
>>> issues as they arise.
>> I pulled git-scsi-misc on July 19 and there was no bsg code in there at
>> all.  I pulled again on July 20 and all the bsg code was in mainline.  So
>> it appears that the bsg code went mailing-list -> mainline in less than 24
>> hours, so there wasn't a lot of opportunity for -mm testing there.
> 
> bsg was merged via Jens' branch. After that, I asked James to send
> some fixes via the scsi-rc-fixes.

ISTR that Jens doesn't regularly push / get picked up by -mm?  That 
seems like an easy problem to solve.

	Jeff




