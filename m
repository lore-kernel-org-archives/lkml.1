Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYGNW1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYGNW1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYGNW1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:27:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773AbYGNW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:27:30 -0400
Date: Mon, 14 Jul 2008 15:27:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core/percpu for v2.6.27
In-Reply-To: <20080714143413.GA19134@elte.hu>
Message-ID: <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org>
References: <20080714143413.GA19134@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Ingo Molnar wrote:
> 
> Please pull the latest core/percpu git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/percpu

Can you explain what this does and who needs it? The percpu_xchg() looks 
particularly pointless, since it's always a locked SMP-safe instruction on 
x86, so a nonpreemptible load+store will likely be much faster.

			Linus
