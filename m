Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbXLQWul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbXLQWul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbXLQWuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:50:32 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43441 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbXLQWub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:50:31 -0500
Date: Mon, 17 Dec 2007 23:50:30 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
In-Reply-To: <20071215174658.5d784075@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0712172349280.32270@fbirervta.pbzchgretzou.qr>
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos>
 <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com>
 <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com>
 <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com>
 <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com>
 <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com>
 <20071214232955.545ab809@the-village.bc.nu> <4763442A.5020507@reed.com>
 <476369E2.8050301@zytor.com> <47640C33.1050106@reed.com>
 <20071215174658.5d784075@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 15 2007 17:46, Alan Cox wrote:
>
>> My understanding is that the linux starts in real mode, and uses the 
>> BIOS for such things as reading the very first image.   
>
>Not always. We may enter from 32bit in some cases, and we may also not
>have a PC BIOS in the first place.

Computers without a PC BIOS (I'm trying to think of something, e.g.
the typical SUN sparc64 box) should have other means of accessing a
clocksource, no?
