Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYCYRGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYCYRGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYCYRG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:06:29 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48794 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbYCYRG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:06:28 -0400
Message-ID: <47E930FD.40304@s5r6.in-berlin.de>
Date: Tue, 25 Mar 2008 18:06:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Meyer <thomas@m3y3r.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu>
In-Reply-To: <20080325165007.GA7775@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> could you please try x86.git/latest:
> 
>   http://people.redhat.com/mingo/x86.git/README
> 
> which has all the fixes and debug patches integrated (no extra patching 
> should be needed). If it still doesnt work then please send the new 
> dmesg and /sys/kernel/debug/kernel_page_tables dump.
> 
> head 0fef904c33841be92f or later.

Just to clarify, in case the thread of discussion caused any confusion:
I only have an unaffected system which never maps MMIO space above 4G.
So far only Thomas M.'s system did this.
-- 
Stefan Richter
-=====-==--- --== ==--=
http://arcgraph.de/sr/
