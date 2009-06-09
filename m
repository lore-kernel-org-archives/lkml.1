Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZFIQma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZFIQma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZFIQmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:42:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbZFIQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:42:03 -0400
Date: Tue, 9 Jun 2009 09:41:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
In-Reply-To: <20090609162808.GC2491@redhat.com>
Message-ID: <alpine.LFD.2.01.0906090940160.6847@localhost.localdomain>
References: <4A2835D8.6040903@kernel.org> <4A2AE4AC.60805@kernel.org> <4A2AE570.2010307@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain> <20090609162808.GC2491@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, Dave Jones wrote:
> 
> work_on_cpu()'s definition could probably use a fat comment describing
> why it sucks.

No, it should be renamed.

The problem is that it _sounds_ like a nice thing to do.

If it was called "slow_other_cpu_thread_switch_with_a_donkey_on_top()", I 
bet people wouldn't be so damn eager to use it.

		Linus
