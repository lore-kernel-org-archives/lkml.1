Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbXGaM4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbXGaM4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbXGaMzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:55:53 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4864 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXGaMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:55:52 -0400
Date: Tue, 31 Jul 2007 13:55:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: John Sigler <linux.kernel@free.fr>
cc: linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: BIOS implementors disabling the LAPIC
In-Reply-To: <46AF2BF8.3000601@free.fr>
Message-ID: <Pine.LNX.4.64N.0707311343410.16158@blysk.ds.pg.gda.pl>
References: <46AEED9E.1050904@free.fr> <Pine.LNX.4.64N.0707311119350.16158@blysk.ds.pg.gda.pl>
 <46AF2BF8.3000601@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, John Sigler wrote:

> The motherboard manufacturer (well, their level 1 support, anyway) told me I
> could "safely enable the LAPIC". If it is safe to enable the LAPIC, then why
> are they disabling it in the BIOS? (They weren't able to tell me whether
> their BIOS triggers SMIs or not...)

 Ask them.

> Is this a "either works or doesn't" situation where hell should break loose if
> I try to enable the LAPIC and it's not supported by the motherboard, or is
> this a "you will silently lose data at the worst possible time" situation?

 It could be either.  For example some IBM hardware used to be known to 
have problems, like the 8254 timer freezing occasionally, when the APIC 
was used and the NMI watchdog enabled.  On some laptops you would get an 
instant hard lockup if you enabled the APIC and used one of the special 
key combinations (whether on purpose or by chance) used to adjust display 
brightness, etc..

> If that were the case, then I could not enable the LAPIC and have NMIs work,
> right?

 It depends on what you want to use NMIs for.  For their PC/AT compatible 
purpose, that is reporting of memory parity/ECC and bus errors, it works 
in either mode.  For any other purpose you need an APIC.

  Maciej
