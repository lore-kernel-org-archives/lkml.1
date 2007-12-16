Return-Path: <linux-kernel-owner+w=401wt.eu-S1765142AbXLPXgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765142AbXLPXgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbXLPXgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:36:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbXLPXgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:36:05 -0500
Message-ID: <4765B622.8030507@zytor.com>
Date: Sun, 16 Dec 2007 15:34:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "David P. Reed" <dpreed@reed.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz> <47645D66.4020506@zytor.com> <20071216094029.GD27280@elte.hu> <47659BF3.4040100@zytor.com> <4765AF78.60307@reed.com> <20071216232353.GC5692@elf.ucw.cz>
In-Reply-To: <20071216232353.GC5692@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> The process of safely making delicate changes here is beyond my 
>> responsibility as just a user - believe me, I'm not suggesting that a risky 
>> fix be put in .24.   I can patch my own kernels, and I can even share an 
>> unofficial patch with others for now, or suggest that Fedora and Ubuntu add 
>> it to their downstream.
>>
>> May I make a small suggestion, though.   If the decision is a DMI-keyed 
>> switch from out-80 to udelay(2)  gets put in, perhaps there should also be 
>> a way for people to test their own configuration for the underlying problem 
>> made available as a script.   Though it is a "hack", all you need to freeze 
>> a problem system is to run a loop doing about 1000 "cat /dev/nvram > 
>> /dev/null"  commands.  If that leads to a freeze, one might ask to have the 
>> motherboard added to the DMI-key list.
> 
> Can you freeze it by catting /dev/rtc, too? That may be significant,
> because that is readable for group audio (at least on some
> systems)... which would smell like "small security hole" to me.
> 									Pavel

Heck, on my system (Fedora 7), it's mode 644...

	-hpa
