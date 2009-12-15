Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZLODwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZLODwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbZLODwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:52:34 -0500
Received: from ozlabs.org ([203.10.76.45]:41705 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022AbZLODwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:52:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build failure
Date: Tue, 15 Dec 2009 14:22:29 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
References: <20091211122648.8b305b52.sfr@canb.auug.org.au> <20091214153528.e29f33a6.sfr@canb.auug.org.au>
In-Reply-To: <20091214153528.e29f33a6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151422.29906.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 03:05:28 pm Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Fri, 11 Dec 2009 12:26:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function 'powernowk8_target':
> > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1139: error: implicit declaration of function 'tsk_cpumask'
> > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1139: warning: passing argument 2 of 'cpumask_copy' makes pointer from integer without a cast
> > include/linux/cpumask.h:466: note: expected 'const struct cpumask *' but argument is of type 'int'
> > 
> > Caused by commit 9dd4c5ab546fcac98cfb9ca24ed5cc1bf7f08334
> > ("cpumask:tsk_cpus_allowed-not-tsk_cpumask") from the rr tree interacting
> > with commit b8cbe7e82ec8b55d7bbdde66fc69e788fde00dc6 ("[CPUFREQ] cpumask:
> > don't put a cpumask on the stack in x86...cpufreq/powernow-k8.c") from
> > the cpufreq tree.
> 
> The cpufreq patch above is now in Linus' tree, so You should add the
> patch below to your tree (or squash it into the affected patch).

Thanks, done and rebased.

Cheers,
Rusty.
