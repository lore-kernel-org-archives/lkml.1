Return-Path: <linux-kernel-owner+w=401wt.eu-S934843AbXHGPL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843AbXHGPL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbXHGPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:11:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44871 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbXHGPLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:11:16 -0400
Message-ID: <46B88B91.4050703@garzik.org>
Date: Tue, 07 Aug 2007 11:11:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>	 <1186458941.6637.44.camel@localhost.localdomain>	 <20070807001429.f8cb3b22.akpm@linux-foundation.org> <1186496712.3414.17.camel@localhost.localdomain>
In-Reply-To: <1186496712.3414.17.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> The initial bsg submit went via the block git tree ... which I believe
> you have in -mm.  We only started taking the updates via the scsi tree

Seven hours before you posted this, in 
<20070807001429.f8cb3b22.akpm@linux-foundation.org>, Andrew already 
noted it was not in -mm.

A trivial examination of the broken-out mm patches backs up the absence 
  of Jens' block tree, too.

So let's put this myth / bad assumption to rest, shall we?


> Yes ... particularly in large trees like SCSI, there's the maintainer
> "bugger if I don't mail it out now I don't get it in for another three
> months" factor.

That factor always exists.  It's not confined to SCSI or large trees. 
It's basic the nature of the merge window.  Nothing new or shocking here.


> bsg had actually been sitting in the block tree since 2.6.21, so it had
> followed the delayed merge rule ... it just seems that it didn't get
> enough integration testing in that six months.  This is what I consider

It didn't get integration testing, at least in part, because it did not 
hit our official pre-release tree.  Quoth Andrew:
> I pulled git-scsi-misc on July 19 and there was no bsg code in there at
> all.  I pulled again on July 20 and all the bsg code was in mainline.



> I don't disagree; my point is that bsg did follow this rule (in fact it

Evidence says otherwise.


> I wouldn't call bsg half baked ... it was very carefully matured.  There
> were just a few integration issues.

I wouldn't call bsg carefully matured, if in addition to not really 
gracing -mm with its presence, the userland API structure is still 
getting changes on July 29, 2007 (0c6a89ba640d28e1dcd7fd1a217d2cfb92ae4953).

	Jeff


