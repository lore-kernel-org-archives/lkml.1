Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYLEDbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYLEDbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYLEDbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:31:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYLEDbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:31:08 -0500
Date: Thu, 4 Dec 2008 19:30:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-Id: <20081204193011.37d2b3cd.akpm@linux-foundation.org>
In-Reply-To: <20081204225345.654705757@linutronix.de>
References: <20081204225345.654705757@linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2008 23:44:39 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> Performance counters are special hardware registers available on most modern
> CPUs. These register count the number of certain types of hw events: such
> as instructions executed, cachemisses suffered, or branches mis-predicted,
> without slowing down the kernel or applications. These registers can also
> trigger interrupts when a threshold number of events have passed - and can
> thus be used to profile the code that runs on that CPU.
> 
> We'd like to announce a brand new implementation of performance counter
> support for Linux. It is a very simple and extensible design that has the
> potential to implement the full range of features we would expect from such
> a subsystem.
> 
> The Linux Performance Counter subsystem (implemented via the patches
> posted in this announcement) provides an abstraction of performance counter
> hardware capabilities. It provides per task and per CPU counters, and it
> provides event capabilities on top of those.
> 
> The code is far from complete - but the basic approach is already there
> and stable.
> 
> The biggest missing detail is lowlevel support for non-Intel CPUs and
> older Intel CPUs - right now the code is implemented for Intel Core2
> (and later) Intel CPUs that have the PERFMON CPU feature. (see below
> a wider list of missing/upcoming features)
> 
> We are aware of the perfmon3 patchset that has been submitted to lkml
> recently. Our patchset tries to achieve a similar end result, with
> a fundamentally different (and we believe, superior :-) design:

There's also the perfctr patchset, which has been available for a long
time.

I believe that established users of this sort of capability often
access it via the supposed-to-be-cross-platform PAPI interface/library.

Please cc perfctr-devel@lists.sourceforge.net on emails related to this
work.

