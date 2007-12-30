Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbXL3XP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbXL3XP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 18:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXL3XPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 18:15:51 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:61847 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbXL3XPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 18:15:50 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sqJGgmaj7HG0wutH9wipg
Message-ID: <4778266B.2060502@reed.com>
Date: Sun, 30 Dec 2007 18:14:51 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>	<20071230144700.78f4605c@the-village.bc.nu>	<20071230152835.GX16946@elte.hu>	<20071230153818.1a554a7e@the-village.bc.nu>	<20071230160132.GA14311@elte.hu>	<20071230164828.039916c8@the-village.bc.nu>	<4777E010.7030703@keyaccess.nl>	<20071230183927.5a5a3c42@the-village.bc.nu>	<4777F297.9070207@keyaccess.nl>	<alpine.LFD.1.00.0712301158410.32517@woody.linux-foundation.org>	<47780B93.4050606@reed.com> <20071230213623.410d480a@the-village.bc.nu>
In-Reply-To: <20071230213623.410d480a@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Now what's interesting is that the outb to port 80 is *faster* than an 
>> outb to an unused port, on my machine.  So there's something there - 
>> actually accepting the bus transaction.   In the ancient 5150 PC, 80 was 
>>     
>
> Yes and I even told you a while back how to verify where it is. From the
> timing you get its not on the LPC bus but chipset core so pretty
> certainly an SMM trap as other systems with the same chipset don't have
> the bug. Probably all that is needed is a BIOS upgrade
>
>   
Actually, I could see whether it was SMM trapping due to AMD MSR's that 
would allow such trapping, performance or debug registers.  Nothing was 
set to trap with SMI or other traps on any port outputs.   But I'm 
continuing to investigate for a cause.  It would be nice if it were a 
BIOS-fixable problem.  It would be even nicer if the BIOS were GPL...
