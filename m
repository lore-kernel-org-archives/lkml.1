Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXLNBvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXLNBvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbXLNBvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:51:13 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:60915 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXLNBvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:51:12 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/E/Bl14v7EPOh4kQxD8Enu
Message-ID: <4761E169.4020407@reed.com>
Date: Thu, 13 Dec 2007 20:50:33 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Newall <david@davidnewall.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<475E95A3.3070801@davidnewall.com>	<20071211142552.2ae6ea9a@the-village.bc.nu>	<47605E4B.6050904@davidnewall.com>	<20071212230030.00511c3f@the-village.bc.nu>	<47612FF9.8060402@reed.com> <20071213132112.66d59aa2@the-village.bc.nu>
In-Reply-To: <20071213132112.66d59aa2@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simulating 1 microsecond delays (assuming LPC meets that goal for 0x80) 
is "absolutely correct" for devices provided on PCI-X running on 3 GHz 
or greater machines?

Well, you are entitled to your opinion.   Seems likely that reading the 
timing specs of such a chipset might be correct, and delaying for a time 
proportional to CPU speed, rather than assuming running 3000 3GHz clock 
cycles is needed on a very fast emulation of an old device that probably 
runs at the fastest bus speed provided in the chipset.

Every device has different timing constraints.  In the real world that I 
live in.

Alan Cox wrote:
> On Thu, 13 Dec 2007 08:13:29 -0500
> "David P. Reed" <dpreed@reed.com> wrote:
>
>   
>> Perhaps what was meant is that ISA-tuned timings make little sense on 
>> devices that are part of the chipset or on the PCI or PCI-X buses?
>>     
>
> No.
>
> ISA as LPC bus is alive and well inside and outside chipsets. Welcome to
> planet earth and the reality of 'its cheaper to reuse cells than design a
> new one'. For the chipset logic like DMA controllers the _p is absolutely
> correct.
>
> Alan
>
>   
