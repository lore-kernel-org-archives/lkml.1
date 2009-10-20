Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZJTQAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZJTQAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZJTQAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:00:39 -0400
Received: from khc.piap.pl ([195.187.100.11]:38654 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZJTQAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:00:38 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Robert Hancock <hancockrwd@gmail.com>
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
References: <m3my46yo5g.fsf@intrepid.localdomain>
	<19147.28614.505296.752363@pilspetsen.it.uu.se>
	<m3vdii51d8.fsf@intrepid.localdomain>
	<19157.6679.939371.469696@pilspetsen.it.uu.se>
	<20091014125344.7d0b2597@lxorguk.ukuu.org.uk>
Date: Tue, 20 Oct 2009 18:00:40 +0200
In-Reply-To: <20091014125344.7d0b2597@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Wed, 14 Oct 2009 12:53:44 +0100")
Message-ID: <m33a5e5a3b.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update: I've connected Kingston SSD instead of Transcend's. The same
errors appear, but now there is a lot of them (> 30 instead of maybe 5
per my test with Transcend).

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> These two may be worth playing with, especially latency. Forcing the
> latency on the problem board would be interesting given that it is a DMA
> transfer that is failing.

Changing the latency byte doesn't seem to change anything. OTOH the
VT6421A mini-PCI card is the only PCI device in system (not counting the
on-CPU AHB-PCI bridge). The problem is also present (to a lesser extent)
when I plug it into x86-64 machine (using mini-PCI adapter). The SSD
works fine if connected to motherboard's NVidia MCP55 SATA controller.

I have read the datasheet and tried some changes to PCI registers but it
doesn't fix it.

I'm going to test x86-64 + VT6421A + Kingston SSD combination soon.

Unfortunately I don't have a (mini) PCI analyser... I will look at
REQ/GNT and similar signals on PCI, though.
-- 
Krzysztof Halasa
