Return-Path: <linux-kernel-owner+w=401wt.eu-S1765082AbXLOUb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765082AbXLOUb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 15:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbXLOUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 15:31:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbXLOUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 15:31:48 -0500
Message-ID: <476438B4.2020600@zytor.com>
Date: Sat, 15 Dec 2007 12:27:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, rol@witbe.net
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com>
In-Reply-To: <47638C8C.2090604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> Yes, just posted a Patch-For-Comments that switches on the availability 
> of a TSC (tsc_init sets tsc_disable also for !cpu_has_tsc) which would 
> mean that only really old stuff would be using the outb still. A TSC is 
> really all we need to have a sensible udelay().
> 

Uhm, no.  You have no clue what the speed of the TSC is until you have 
been able to calibrate it against a fixed timesource - like the PIT.

	-hpa
