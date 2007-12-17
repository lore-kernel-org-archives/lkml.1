Return-Path: <linux-kernel-owner+w=401wt.eu-S1764518AbXLQCFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764518AbXLQCFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765530AbXLQCF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:05:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765289AbXLQCF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:05:28 -0500
Message-ID: <4765D922.3050703@zytor.com>
Date: Sun, 16 Dec 2007 18:04:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: "David P. Reed" <dpreed@reed.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <4765B0CF.2040000@reed.com> <4765D745.7040306@gmail.com>
In-Reply-To: <4765D745.7040306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 17-12-07 00:12, David P. Reed wrote:
> 
>> Rene Herman wrote:
>>> David: I've plugged in your DMI values in this. Could you perhaps 
>>> test this to confirm that it works for you?
>>>
>> Will test it by tomorrow morning.
> 
> Might as well test the new version then. Ingo Molnar requested a few 
> changes and this fixes a couple of problems as well.
> 

As far as I can tell, the code still uses udelay() before calibration if 
io_delay=udelay?

Just so we're clear on that...

	-hpa
