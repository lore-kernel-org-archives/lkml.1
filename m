Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXJ3Syd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXJ3Syd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXJ3SyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:54:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbXJ3SyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:54:22 -0400
Date: Tue, 30 Oct 2007 11:54:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>, Mikael Pettersson <mikpe@it.uu.se>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
In-Reply-To: <20071030184502.GA27246@havoc.gtf.org>
Message-ID: <alpine.LFD.0.999.0710301151000.30120@woody.linux-foundation.org>
References: <20071030184502.GA27246@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Jeff Garzik wrote:
> 
> Mikael Pettersson (2):
>       sata_promise: ASIC PRD table bug workaround, take 2
>       sata_promise: cleanups

You and Mikael need to sort out the way you send/accept patches. 

Both of these commits had stuff like this:

    Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
    --
    Changes since previous version:
    * use new PDC_MAX_PRD constant to initialise sg_tablesize
    
     drivers/ata/sata_promise.c |   87 ++++++++++++++++++++++++++++++++++++++++++---
     1 files changed, 83 insertions(+), 4 deletions(-)
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

which seems to be because Mikael uses two dashes instead of three to 
separate his "real message" from the stuff you have.

So either you need to teach Mikael to use the proper separators, or you 
need to edit these things down to be something readable instead of keeping 
the extraneous commentary around...

Pulled, but I'm hoping for cleaner commit messages in the future..

		Linus
