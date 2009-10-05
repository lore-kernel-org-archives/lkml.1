Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZJES6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZJES6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZJES63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:58:29 -0400
Received: from www.tglx.de ([62.245.132.106]:50964 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZJES63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:58:29 -0400
Date: Mon, 5 Oct 2009 20:57:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Mehlan, Markus" <Markus.Mehlan@ritter.info>
cc: linux-kernel@vger.kernel.org
Subject: Re: clock_nanosleep: cyclic POSIX thread freezes during time
 setting
In-Reply-To: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL>
Message-ID: <alpine.LFD.2.00.0910052044410.2646@localhost.localdomain>
References: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Mon, 5 Oct 2009, Mehlan, Markus wrote:
> I have the following problem on a MPC5200b customer board,
> tested with linux-2.6.24.7-rt11 and 2.6.26.8-rt16.
> 
> I start the test application. Every 200ms I can see a new 
> line on the console ("ping"). Then I set the time with "date
> 100509152009" a few times on
> a second console. The effect is that the output on the first console
> freezes and if I check
> the time with "date", the time doesn't progress during the "freeze
> time". After the 
> "freeze time" the time makes a jump of several seconds.
> 
> In the real application the "ping" should reset the watchdog-timer. The
> freezing causes
> an elapsing of the watchdog-timer and finally a reboot.
> 
> Has someone an idea?

Just tested on a MPC5200 board with cyclictest and setting date on a
second console. Unfortunately I cannot reproduce that problem. Can you
try to activate the function tracer and capture what the system is
doing. That might us give some clue about the problem.

Thanks,

	tglx


 

