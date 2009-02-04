Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZBDARy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZBDARy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZBDARn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:17:43 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:57079 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZBDARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:17:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OueKB0WiHuijQTLn3J9o2MNBOaB1ruKMa/6twOW1dkOdYKLLH1lV2kjK9WW5LfOHCr
         N9b1r1CD1LPcoTC+cHZO2H8xFeif0njHyI7R9DqKmZY3/9yPcDVs0oqqBAOkDWxT4c80
         jiNOIwzKeebfL+xEoYJhbuUfXiXpGG5Wg4BTM=
Date: Tue, 3 Feb 2009 19:17:33 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: WARNING: at drivers/pci/pci-driver.c:368
In-Reply-To: <200902040110.21455.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0902031912520.7017@parag-laptop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902032315.27113.rjw@sisk.pl> <alpine.DEB.2.00.0902031821590.7302@parag-laptop> <200902040110.21455.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:

> On Wednesday 04 February 2009, Parag Warudkar wrote:
> > 
> > Today's git triggers the below warning on suspending my laptop, which is -
> > 
> > if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
> > 
> > Would it be helpful to also print info about the device that was not in 
> > PCI_D0?
> 
> Yes, the patch for that is on its way to Jesse.

Actually judging by the INT disabled message that appears after the 
WARN_ON - 

0000:01:00.0: PCI INT A disabled

It seems to be the PCI bridge that was in D0 - 
00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express 
Root Port (rev 0c)

(Or did you mean patch to fix the WARN_ON is on the way - that would be 
even better :)
> 
> BTW, may I ask what about the last patch I sent to you? :-)
> 

Sure :) I will let you know shortly, the desktop machine is compiling 
right now, once that's done...

Thanks
Parag
