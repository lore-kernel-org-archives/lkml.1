Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXJFVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXJFVP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763667AbXJFVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:15:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38604 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764295AbXJFVPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:15:13 -0400
X-Sasl-enc: iGQFE4Uv6L/q1DRVhqNCdTgr7+93azg29himlcybvmlC 1191705310
Subject: Re: cx88 pci_abort messages
From: Scott <linux-kernel@bluecamel.eml.cc>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4707D876.8080306@shaw.ca>
References: <fa.9BwFZjxkV7dKD7EmsWMTtKId3Qc@ifi.uio.no>
	 <fa.m+2QwZVzW3oTWJBsJ4fdAiUZWkM@ifi.uio.no>  <4707D876.8080306@shaw.ca>
Content-Type: text/plain
Date: Sat, 06 Oct 2007 17:15:03 -0400
Message-Id: <1191705303.7536.6.camel@oasis.donpoo.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-06 at 12:48 -0600, Robert Hancock wrote:
> > On Oct 4, 2007, at 11:52 AM, Scott wrote:
> > 
> >> I'm having what I think is a PCI bus problem.
> >>
> >> I have a ASUS P5B Intel 965 motherboard and a DVICO Fusion HDTV5 RT
> >> adapter on the PCI bus. When this adapter is recording (anything) I see
> >> Oct  2 21:59:12 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
> >> Oct  2 21:59:12 htpc cx88[0]/2-mpeg: general errors: 0x00080000
> >> Oct  2 21:59:20 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
> >> Oct  2 21:59:20 htpc cx88[0]/2-mpeg: general errors: 0x00080000
> >> Oct  2 21:59:32 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
> >> Oct  2 21:59:32 htpc cx88[0]/2-mpeg: general errors: 0x0008000
> >
> PCI aborts won't have anything to do with interrupts. It's a PCI DMA 
> transfer that either the initiator (here, the TV card) or the target 
> (the chipset host bridge) decided to puke on for some reason. Possibly 
> parity errors?

I assumed it was an interrupt issue based on the 'irq mepg' error, not a
DMA issue. Any suggestions on how to log more information about PCI DMA
events on a system wide basis? 

I've seen this since 2.6.18.

-- 
Scott <linux-kernel@bluecamel.eml.cc>

