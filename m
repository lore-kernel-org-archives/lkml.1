Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZJFJO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZJFJO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbZJFJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:14:28 -0400
Received: from www.tglx.de ([62.245.132.106]:58100 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbZJFJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:14:27 -0400
Date: Tue, 6 Oct 2009 11:13:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Mehlan, Markus" <Markus.Mehlan@ritter.info>
cc: linux-kernel@vger.kernel.org
Subject: Re: AW: clock_nanosleep: cyclic POSIX thread freezes during time
 setting
In-Reply-To: <40F775BBD072A346957E787B3D0DBE5F1C97B4@w2k3-46ex01.RITTER.LOCAL>
Message-ID: <alpine.LFD.2.00.0910061112400.2646@localhost.localdomain>
References: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910052044410.2646@localhost.localdomain> <40F775BBD072A346957E787B3D0DBE5F1C97B4@w2k3-46ex01.RITTER.LOCAL>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Mehlan, Markus wrote:
> > Just tested on a MPC5200 board with cyclictest and setting 
> > date on a second console. Unfortunately I cannot reproduce 
> > that problem. Can you try to activate the function tracer and 
> > capture what the system is doing. That might us give some 
> > clue about the problem.
> > 
> do you mean kernel function trace (KFT patch) with function trace
> or user space "strace"?

The kernel function tracer which is in -rt. strace is not telling us
what's happening in the kernel.

Thanks,

	tglx
