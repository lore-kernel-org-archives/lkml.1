Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbXLLVg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbXLLVg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXLLVgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:36:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46149 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbXLLVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:36:16 -0500
Date: Wed, 12 Dec 2007 21:29:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rene Herman <rene.herman@gmail.com>, "David P. Reed" <dpreed@reed.com>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: More info on port 80 symptoms on MCP51 machine.
Message-ID: <20071212212922.2cf5339b@the-village.bc.nu>
In-Reply-To: <47604EA4.50504@zytor.com>
References: <475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
	<20071211084059.3d03e11d@tux.DEF.witbe.net>
	<475E5D4B.8020101@keyaccess.nl>
	<475E7DC2.4060509@davidnewall.com>
	<475E8D91.20201@keyaccess.nl>
	<475E95A3.3070801@davidnewall.com>
	<Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com>
	<20071211163017.GD16750@one.firstfloor.org>
	<475EBFBA.6090301@keyaccess.nl>
	<20071211191649.GB3437@elf.ucw.cz>
	<475EEC75.80609@keyaccess.nl>
	<47603F66.3070108@reed.com>
	<476043DA.5000602@keyaccess.nl>
	<47604B71.7090902@keyaccess.nl>
	<20071212210143.48721a41@the-village.bc.nu>
	<47604EA4.50504@zytor.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One wonders if it does some SMM trick to capture port 0x80 writes and 
> attempt to haul them off for debugging; it almost sounds like some kind 
> of debugging code got let out into the field.

Not implausible. We've got a bug I've been dealing with where a vendor
left debug stuff enabled via the parallel port and which clearly
"escaped" from the test environment to the BIOS proper.
