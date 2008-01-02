Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbYABCaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbYABCaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYABC3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:29:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYABC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:29:54 -0500
Message-ID: <477AF679.1060900@zytor.com>
Date: Tue, 01 Jan 2008 18:27:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu>	<20071215080831.404cdb32@tux.DEF.witbe.net>	<47638C8C.2090604@gmail.com>	<476438B4.2020600@zytor.com>	<476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<4765D95C.4010404@zytor.com>	<4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<477AAD7B.5040405@zytor.com>	<477AB204.3070904@keyaccess.nl>	<477AB433.5070506@zytor.com>	<477AC02A.40108@keyaccess.nl>	<477AC130.3050901@zytor.com>	<477AC8BA.2050503@keyaccess.nl> <20080102015539.58d80332@weinigel.se>
In-Reply-To: <20080102015539.58d80332@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> 
> Both 0xed and 0xf0 are mapped to internal functions on the AMD Elan
> SC400 processor.  It is an AMD 486 based system on a chip and since AMD
> just knew that it would never have a math coprocessor, they reused the
> 0xf0-0xf2 range for the PCMCIA controller.  I guess the AMD Elan SC500
> will have similar problems.
> 
> I seem to recall that back when I was working with the Elan SC400
> (sometime around 1998?) there were discussions about finding an
> alternate delay port because outb to 0x80 messed up the debug port.  I
> think the Elan stopped those discussions because just about every port
> on the Elan was reused for some alternate purpose.  
> 

Yeah, the Elan is not supportable anyway without a CONFIG option (it's 
broken in so many ways), so it doesn't really apply.  It's a fuckwit design.

	-hpa
