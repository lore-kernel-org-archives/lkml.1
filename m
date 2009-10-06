Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZJFJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZJFJBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZJFJBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:01:34 -0400
Received: from mci007.btnet.de ([194.172.160.7]:45155 "EHLO relay.btnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbZJFJB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:01:27 -0400
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: AW: clock_nanosleep: cyclic POSIX thread freezes during time setting
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Date: Tue, 6 Oct 2009 11:00:45 +0200
Message-ID: <40F775BBD072A346957E787B3D0DBE5F1C97B4@w2k3-46ex01.RITTER.LOCAL>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: clock_nanosleep: cyclic POSIX thread freezes during time setting
thread-index: AcpF7bwMg+sc7tIxQXimT2GCc4i5+gAbPUsA
References: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910052044410.2646@localhost.localdomain>
From: "Mehlan, Markus" <Markus.Mehlan@ritter.info>
To: "Thomas Gleixner" <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

> -----Ursprüngliche Nachricht-----
> Von: Thomas Gleixner [mailto:tglx@linutronix.de] 
> Gesendet: Montag, 5. Oktober 2009 20:58
> An: Mehlan, Markus
> Cc: linux-kernel@vger.kernel.org
> Betreff: Re: clock_nanosleep: cyclic POSIX thread freezes 
> during time setting
> 
> Markus,
> 
> On Mon, 5 Oct 2009, Mehlan, Markus wrote:
> > I have the following problem on a MPC5200b customer board, 
> tested with 
> > linux-2.6.24.7-rt11 and 2.6.26.8-rt16.
> > 
> > I start the test application. Every 200ms I can see a new 
> line on the 
> > console ("ping"). Then I set the time with "date 
> 100509152009" a few 
> > times on a second console. The effect is that the output on 
> the first 
> > console freezes and if I check the time with "date", the 
> time doesn't 
> > progress during the "freeze time". After the "freeze time" the time 
> > makes a jump of several seconds.
> > 
> > In the real application the "ping" should reset the watchdog-timer. 
> > The freezing causes an elapsing of the watchdog-timer and finally a 
> > reboot.
> > 
> > Has someone an idea?
> 
> Just tested on a MPC5200 board with cyclictest and setting 
> date on a second console. Unfortunately I cannot reproduce 
> that problem. Can you try to activate the function tracer and 
> capture what the system is doing. That might us give some 
> clue about the problem.
> 
> Thanks,
> 
> 	tglx
> 
do you mean kernel function trace (KFT patch) with function trace
or user space "strace"?

Thank you,
Markus

Sitz der Gesellschaft: Oberhausen
Handelsregister Amtsgericht Duisburg HRB-Nr. 17168 UST ID-Nr. DE 814009849
Geschaftsfuehrer: Manfred A. Wagner und Dr. Uwe Baader

