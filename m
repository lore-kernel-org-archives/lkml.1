Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYAKCJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYAKCJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYAKCIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:08:53 -0500
Received: from mail001.aei.ca ([206.123.6.130]:44544 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYAKCIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:08:52 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>, Matthew <jackdachef@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Date: Thu, 10 Jan 2008 21:22:51 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801102122.51507.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> - if yes, does booting with "nmi_watchdog=2 idle=poll" give you a 
>>   working NMI watchdog? (working NMI watchdog means the NMI counts 
>>   increase for all cores in /proc/interrupts).

> booting with the above gives me an incrementing NMI counter in /proc/interrupts

Ingo,

Is there anything else that needs to be set in the kernel config for the nmi watchdog to trigger?

I ask because I just had a hang but nothing showed on the _serial_ console - I waited a couple
of minutes before rebooting....  Is there any other way to verify the watchdog is working?

I seem to need X active with mix of 32 and 64 bit applications active to get hung here.  A massivily
threaded 64 bit java app along with 32 bit firefox and a wine active will eventually trigger things here.
If I had to guess I would say that it the switch from 32 to 64 (or vise versa) that triggers the isuue.

TIA & test/debug patches welcome,
Ed Tomlinson

