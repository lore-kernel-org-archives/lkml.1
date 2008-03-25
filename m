Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYCYVCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYCYVCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYCYVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:02:38 -0400
Received: from www17.your-server.de ([213.133.104.17]:44607 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYCYVCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:02:38 -0400
Message-ID: <47E96850.3010209@m3y3r.de>
Date: Tue, 25 Mar 2008 22:02:08 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu>
In-Reply-To: <20080325201125.GD15330@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> * Thomas Meyer <thomas@m3y3r.de> wrote:
>
>   
>> The kernel boots, but hangs at "populating dev tree with devices 
>> usings uevents". After removing both firewire drivers (ohci1394 and 
>> firewire_ohci) the system comes up correctly.
>>
>> See attached file.
>>
>> Modprobing either ohci1394 or firewire_ohci seems to lock up the 
>> system.
>>     
>
> that's weird. If you do the modprobe from a VGA console and do a 'dmesg 
> -n 8', do you get any ioremap printk shortly before the hard lockup
All i get is:

[ 1175.600768] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, 
low) -> IRQ 19

no ioremap debug offset.


