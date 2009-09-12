Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZILJwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZILJwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 05:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZILJwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 05:52:01 -0400
Received: from borg.medozas.de ([188.40.89.202]:33410 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbZILJwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 05:52:00 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Sep 2009 05:52:00 EDT
Date: Sat, 12 Sep 2009 11:44:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>, Fra@jasper.es
Subject: Re: [ANNOUNCE] 2.6.29.6-rt23
In-Reply-To: <alpine.LSU.2.00.0908111140280.5036@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LSU.2.00.0909121124340.15677@obet.zrqbmnf.qr>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>  <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>  <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> 
 <alpine.LFD. <alpine.LFD.2.00.0907102023500.2768@localhost.localdomain> <alpine.LSU.2.00.0908111140280.5036@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2009-08-11 12:52, Jan Engelhardt wrote:
>On Friday 2009-07-10 20:29, Thomas Gleixner wrote:
>>On Fri, 10 Jul 2009, Fernando Lopez-Lezcano wrote:
>>> 
>>> I'm getting slightly weird behavior from rt23 in an intel quad core
>>> machine (my T61 laptop is fine), rt22 was fine. It is some timer issue,
>>> if I type continuously I get (every few seconds) repeated keys. Nothing
>>> in the logs, nothing in dmesg that is (significantly) different from an
>>> rt22 boot. 
>
>I am getting the same issue, reliably reproducibly - though ironically
>only with the proprietary NVIDIA. Key repeats, screen going "No signal"
>for a sec, sometimes comes back, sometimes hangs the whole machine.

The problem is reproducible on 2.6.31-rc8-rt9. Keys repeat, and the
patch for 2.6.31-rt does not want to compile anymore.
