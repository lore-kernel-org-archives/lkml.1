Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYHZWtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYHZWtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYHZWto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:49:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47592 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYHZWto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:49:44 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Andi Kleen <andi@firstfloor.org>
References: <20080819103301.787700742@chello.nl>
	<200808261954.47987.nickpiggin@yahoo.com.au>
	<alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de>
	<200808262127.26803.nickpiggin@yahoo.com.au>
	<alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de>
Date: Wed, 27 Aug 2008 00:49:36 +0200
In-Reply-To: <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> (Thomas Gleixner's message of "Tue, 26 Aug 2008 23:37:08 +0200 (CEST)")
Message-ID: <874p57s873.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> Well, we might have a public opinion poll, whether a system is
> declared frozen after 1, 10 or 100 seconds. Even a one second
> unresponsivness shows up on the kernel bugzilla and you request that
> unlimited unresponsivness w/o a chance to debug it is the sane
> default.

That assumes single CPU. With multiple CPUs and not
all hogged the system should be still responsive? 

-Andi
