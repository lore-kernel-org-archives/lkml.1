Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbXLLVKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbXLLVKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXLLVKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:10:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbXLLVKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:10:22 -0500
Message-ID: <47604D1D.8000003@zytor.com>
Date: Wed, 12 Dec 2007 13:05:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: More info on port 80 symptoms on MCP51 machine.
References: <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl> <20071211191649.GB3437@elf.ucw.cz> <475EEC75.80609@keyaccess.nl> <47603F66.3070108@reed.com> <476043DA.5000602@keyaccess.nl> <47604B71.7090902@keyaccess.nl>
In-Reply-To: <47604B71.7090902@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 12-12-07 21:26, Rene Herman wrote:
> 
>> On 12-12-07 21:07, David P. Reed wrote:
> 
>>> Someone might have an in to nVidia to clarify this, since I don't.  
>>> In any case, the udelay(2) approach seems to be a safe fix for this 
>>> machine.
> 
> By the way, _does_ anyone have a contact at nVidia who could clarify? 
> Alan maybe? I'm quite curious what they did...
> 
> Summary:
> 
> Unless after booting with "acpi=off", outputs to port 0x80 (the legacy 
> way to delay I/O) reliably, but not immediately, hang MCP51 machines. 
> Outputs to port 0xed do not indicating it's a not a generic bus abort 
> problem.
> 

Sorry, the first sentence didn't parse unambiguously for me.  Do you 
mean "acpi=off" works, or that "acpi=off" allows *subsequent* boots to work?

I have some people at nVidia I can probably ping.

	-hpa
