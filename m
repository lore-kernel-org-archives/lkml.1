Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYH2PlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYH2PlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYH2Pky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:40:54 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34371 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYH2Pky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:40:54 -0400
X-Sasl-enc: v47QPwEsgQBsfvffGggmHJfcpFvLY8tdAaC3Pw/3HN6z 1220014623
Message-ID: <48B7F21D.5070509@ladisch.de>
Date: Fri, 29 Aug 2008 14:57:01 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Robert M. Stockmann" <stock@stokkie.net>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: libata, Sound on same IRQ : flaky sound
References: <Pine.LNX.4.44.0808281918150.19541-100000@hubble.stokkie.net>
In-Reply-To: <Pine.LNX.4.44.0808281918150.19541-100000@hubble.stokkie.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert M. Stockmann wrote:
> On Thu, 28 Aug 2008, Robert Hancock wrote:
> > Robert M. Stockmann wrote:
> > > How about giving your sound device a proper seperate IRQ number?
> > > At least libata should like eth0 have its own kernel resources.
> >
> > That's an issue with the way the motherboard IRQ lines are wired.
> > There's nothing the kernel can do about it.
>
> That sounds rather strange to me, as IRQ line 16 is a virtual
> IRQ as part of IO-APIC.

The IRQ isn't virtual; in IO-APIC mode, all PCI interrupts (PCI cards
and internal PCI devices) are hard-wired to certain interrupt vectors.


Regards,
Clemens
