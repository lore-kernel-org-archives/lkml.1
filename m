Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbXJaJio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbXJaJio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJaJie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:38:34 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37240 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbXJaJid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:38:33 -0400
Date: Wed, 31 Oct 2007 10:38:14 +0100 (MET)
Message-Id: <200710310938.l9V9cEUM006861@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: jeff@garzik.org, mikpe@it.uu.se, torvalds@linux-foundation.org
Subject: Re: [git patches] libata fixes
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 11:54:01 -0700 (PDT), Linus Torvalds wrote:
> On Tue, 30 Oct 2007, Jeff Garzik wrote:
> > 
> > Mikael Pettersson (2):
> >       sata_promise: ASIC PRD table bug workaround, take 2
> >       sata_promise: cleanups
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
> So either you need to teach Mikael to use the proper separators

That's my fault for misremembering the rule about the
number of dashes before the other comments part :-(
I'll remember better in the future.

/Mikael
