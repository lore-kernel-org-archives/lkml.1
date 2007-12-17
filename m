Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXLQVVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXLQVVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbXLQVVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:21:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51643 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbXLQVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:21:37 -0500
Message-ID: <4766E765.4080006@zytor.com>
Date: Mon, 17 Dec 2007 13:17:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <4766D443.6040805@zytor.com> <4766E3DC.50700@reed.com>
In-Reply-To: <4766E3DC.50700@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> 
> Note that I can run the port 80 test once, the second time I get the 
> hard freeze.  I didn't try writing to port 70 from userspace - that 
> one's dangerous, but the reading of it was included for a timing typical 
> of a chipset supported device.  These are all pretty consistent.
> 
> I find the "read" timing from 0x80 verrrrry interesting.  The write 
> timeing is also interesting, being faster than an unused port.
> 

Once again: reading from port 0x80 goes to the DMA page device.

	-hpa
