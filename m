Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYISSVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYISSVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYISSVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:21:45 -0400
Received: from www.tglx.de ([62.245.132.106]:50152 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYISSVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:21:44 -0400
Date: Fri, 19 Sep 2008 11:21:19 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Valdis.Kletnieks@vt.edu, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: c1e_idle: don't mark TSC unstable if CPU has
 invariant TSC
In-Reply-To: <20080919172019.GA16896@alberich.amd.com>
Message-ID: <alpine.LFD.1.10.0809191119250.3650@apollo.tec.linutronix.de>
References: <20080918191210.GD23287@alberich.amd.com> <27087.1221766532@turing-police.cc.vt.edu> <20080919172019.GA16896@alberich.amd.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008, Andreas Herrmann wrote:
> TSC on K8 is not P-state and C-state invariant.
> Thus on K8 you'll have a TSC drift if C1E is entered.
> 
> This means that if C1E is enabled TSC should be marked unstable on
> those CPUs (it shouldn't be used as a clocksource).

Correct. I missed that detail with the newer CPUs when I did the C1E
idle stuff. Thanks for catching it. I'll schedule it for Linus when
I'm back from Portland.

Thanks,

	tglx
