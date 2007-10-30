Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbXJ3TMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbXJ3TMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXJ3TMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:12:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42915 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbXJ3TML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:12:11 -0400
Message-ID: <47278206.2080601@garzik.org>
Date: Tue, 30 Oct 2007 15:12:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20071030184502.GA27246@havoc.gtf.org> <alpine.LFD.0.999.0710301151000.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710301151000.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 30 Oct 2007, Jeff Garzik wrote:
>> Mikael Pettersson (2):
>>       sata_promise: ASIC PRD table bug workaround, take 2
>>       sata_promise: cleanups
> 
> You and Mikael need to sort out the way you send/accept patches. 
> 
> Both of these commits had stuff like this:
> 
>     Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
>     --
>     Changes since previous version:
>     * use new PDC_MAX_PRD constant to initialise sg_tablesize
>     
>      drivers/ata/sata_promise.c |   87 ++++++++++++++++++++++++++++++++++++++++++---
>      1 files changed, 83 insertions(+), 4 deletions(-)
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> which seems to be because Mikael uses two dashes instead of three to 
> separate his "real message" from the stuff you have.
> 
> So either you need to teach Mikael to use the proper separators, or you 
> need to edit these things down to be something readable instead of keeping 
> the extraneous commentary around...
> 
> Pulled, but I'm hoping for cleaner commit messages in the future..

Can we change git-am to accept two dashes as well as three?  :)

It seems pretty common, not just with Mikael but several others who send 
patches to me.

	Jeff



