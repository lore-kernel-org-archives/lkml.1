Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbXLPAHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbXLPAHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXLPAG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:06:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbXLPAG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:06:56 -0500
Message-ID: <47646BDE.5080006@zytor.com>
Date: Sat, 15 Dec 2007 16:05:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, rol@witbe.net
Subject: Re: [PATCH] x86: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com>
In-Reply-To: <4764687D.6080609@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Note, however, that your code doesn't deal with io_delay()'s in the boot 
> code (arch/x86/boot) at all, nor (obviously) io_delay()'s in boot 
> loaders.  In the boot code, access to DMI data is NOT available (we 
> can't even use the INT 15h mover if we want to continue to support 
> Loadlin.)
>

Correction: DMI data are at least supposedly available via the PNPBIOS 
calls specified in the SMBIOS spec.

	-hpa
