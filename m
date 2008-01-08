Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYAHTQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYAHTQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYAHTQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:16:11 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:49652 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbYAHTQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:16:10 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.106
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/hicg/AD3GU6ZVzP46YYnt
Message-ID: <4783CBD9.7020709@reed.com>
Date: Tue, 08 Jan 2008 14:15:37 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ondrej Zary <linux@rainbow-software.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com> <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
In-Reply-To: <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The natsemi docs here say otherwise. I trust them not you.
>   
As well you should. I am honestly curious (for my own satisfaction) as 
to what the natsemi docs say the delay code should do  (can't imagine 
they say "use io port 80 because it is unused").  I don't have any 
copies anymore. But mere curiosity on my part is not worth spending a 
lot of time on - I know you are super busy.   If there's a copy online 
at a URL ...
>
> The problem is that certain people, unfortunately those who know
> nothing about ISA related bus systems, keep trying to confuse ISA delay
> logic with core chip logic and end up trying to solve both a problem and a
> non-problem in one, creating a nasty mess in the process.
>
>   
I agree that the problems of chip logic and ISA delay are all tangled 
up, probably more than need be.  I hope that the solution turns out to 
simplify matters, and hopefully to document the intention of the 
resulting code sections a bit more clearly for the future.
