Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbXLORyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbXLORyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 12:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXLORys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 12:54:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42446 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752504AbXLORyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 12:54:47 -0500
Date: Sat, 15 Dec 2007 17:46:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
Message-ID: <20071215174658.5d784075@the-village.bc.nu>
In-Reply-To: <47640C33.1050106@reed.com>
References: <469578CD.3080609@reed.com>
	<1184216528.12353.203.camel@chaos>
	<1184218962.12353.209.camel@chaos>
	<46964352.7040301@reed.com>
	<1184253339.12353.223.camel@chaos>
	<469697C6.50903@reed.com>
	<1184274754.12353.254.camel@chaos>
	<4761F193.7090400@reed.com>
	<20071214131502.GA14359@elte.hu>
	<4762C551.5070003@zytor.com>
	<20071214210652.GB28793@elf.ucw.cz>
	<4763001A.1070102@zytor.com>
	<20071214232955.545ab809@the-village.bc.nu>
	<4763442A.5020507@reed.com>
	<476369E2.8050301@zytor.com>
	<47640C33.1050106@reed.com>
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

> My understanding is that the linux starts in real mode, and uses the 
> BIOS for such things as reading the very first image.   

Not always. We may enter from 32bit in some cases, and we may also not
have a PC BIOS in the first place.
