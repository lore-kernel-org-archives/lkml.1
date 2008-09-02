Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYIBEzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYIBEzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 00:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYIBEy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 00:54:57 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41398 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbYIBEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 00:54:56 -0400
Message-ID: <48BCC723.3090007@lwfinger.net>
Date: Mon, 01 Sep 2008 23:54:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alok Kataria <akataria@vmware.com>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On the machine you have trouble with the PIT on, does this thing trigger?
> 
> If it does, that could be a simple way to say whether you prefer PM_TIMER 
> over PIT.
> 
> For me, even on a modern machine, I get a pit_count of 46321, which 
> matches the "about one microsecond for an ISA/LPC read" timing pretty 
> well. What do you get? 

On the problem AMD K6, the count is 29411. On my almost new AMD Turion 
64 X2 that runs at 2.0 GHz, the value was 31401. A cutoff value of 
25000 may be a bit close. That machine says that it calibrates against 
the PM_TIMER, but cat /sys/devices/...../current_clocksource returns 
hpet.

Larry
