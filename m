Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbYAKPIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbYAKPIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbYAKPIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:08:30 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:56016 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbYAKPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:08:29 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.106
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183mSl+oakwRA3exwvOmL8k
Message-ID: <4787864C.1090101@reed.com>
Date: Fri, 11 Jan 2008 10:07:56 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rene Herman <rene.herman@keyaccess.nl>, Zachary Amsden <zach@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	<47845972.9090803@zytor.com>	<1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	<47854916.4080703@reed.com>	<1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>	<4786DD05.20804@keyaccess.nl>	<47877ECD.9060408@reed.com> <20080111143748.35883ff7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080111143748.35883ff7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> bus abort on the LPC bus".   More problematic is that I would think some 
>> people might want to turn on the AMD feature that generates machine 
>> checks if a bus timeout happens.   The whole point of machine checks is 
>>     
>
> An ISA/LPC bus timeout is fulfilled by the bridge so doesn't cause an MCE.
>
>
>   
Good possibility, but the documentation on HyperTransport suggests 
otherwise, even for LPC bridges in this particular modern world of 
AMD64. I might do the experiment someday to see if my LPC bridge is 
implemented in a way that does or doesn't support enabling MCE's. Could 
be different between Intel and AMD - I haven't had reason to pore over 
the Intel chipset specs, since my poking into all this stuff has been 
driven by my personal machine's issues, and it's not got any Intel 
compatible parts.
