Return-Path: <linux-kernel-owner+w=401wt.eu-S936735AbXLQUKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936735AbXLQUKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934816AbXLQToX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:44:23 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:50221 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675AbXLQToW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:44:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.136
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183o7C+MHlf3l7ObqBBGsBn
Message-ID: <4766D175.7040807@reed.com>
Date: Mon, 17 Dec 2007 14:43:49 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com>
In-Reply-To: <4766AE88.4080904@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Rene Herman wrote:
>>
>> I do not know how universal that is, but _reading_ port 0xf0 might in 
>> fact be sensible then? And should even work on a 386/387 pair? (I 
>> have a 386/387 in fact, although I'd need to dig it up).
>>
>
> No.  Someone might have used 0xf0 as a readonly port for other uses.
>
As support: port 80 on the reporter's (my) HP dv9000z laptop clearly 
responds to reads differently than "unused" ports.  In particular, an 
inb takes 1/2 the elapsed time compared to a read to "known" unused port 
0xed - 792 tsc ticks for port 80 compared to about 1450 tsc ticks for 
port 0xed and other unused ports (tsc at 800 MHz).

