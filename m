Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYAHBiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYAHBiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYAHBiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:38:46 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:61207 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYAHBip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:38:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19R3U0EJnS9Nu532Our9gbd
Message-ID: <4782D407.7010301@reed.com>
Date: Mon, 07 Jan 2008 20:38:15 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl> <4782B4B9.2020608@zytor.com> <4782B515.3010008@keyaccess.nl> <4782BF77.80703@reed.com> <4782C017.3000208@zytor.com>
In-Reply-To: <4782C017.3000208@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>
> And shoot the designer of this particular microcontroller firmware.
>
>  
Well, some days I want to shoot the "designer" of the entire Wintel 
architecture...  it's not exactly "designed" by anybody of course, and 
today it's created largely by a collection of Taiwanese and Chinese ODM 
firms, coupled with Microsoft WinHEC and Intel folks.  At least they 
follow the rules and their ACPI and BIOS code say that they are using 
port 80 very clearly if you use PnP and ACPI properly.  And in the old 
days, you were "supposed" to use the system BIOS to talk to things like 
the PIT that had timing issues, not write your own code.

Or perhaps the ACPI spec should specify a timing loop spec and precisely 
specify the desired timing after accessing an I/O port till that device 
has properly "acted" on that operation.

The idea that Port 80 was "unused" and appropriate for delay purposes 
elicited skepticism by Linus that is recorded for posterity in the 
comments of the relevant Linux include files - especially since it was 
clearly "used" for non-delay purposes, by cards that could be plugged 
into a PCI (fast), not just an 8-bit ISA, bus.

Perhaps we should declare the world of ACPI systems a separate "arch" 
from the world of l'ancien regime where folklore about which ports were 
used for what ruled.   I lived through those old days, and they were not 
wonderful, either.

The world sucks, and Linux is supposed to be able to adapt to that 
world, suckitude and all.

