Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZARXAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZARXAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZARXAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:00:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbZARXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:00:00 -0500
Date: Sun, 18 Jan 2009 23:59:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Leonardo Potenza <leo.potenza@gmail.com>
Cc: kernel-janitors@vger.kernel.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix section mismatch warnings in
	kernel/setup_percpu.c
Message-ID: <20090118225945.GA3845@elte.hu>
References: <200901182303.56911.lpotenza@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901182303.56911.lpotenza@inwind.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0775]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Leonardo Potenza <leo.potenza@gmail.com> wrote:

> From: Leonardo Potenza <lpotenza@inwind.it>
> 
> The function setup_cpu_local_masks() has been marked __init, in order to remove the following section mismatch messages:
> 
> WARNING: vmlinux.o(.text+0x3c2c7): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
> The function setup_cpu_local_masks() references
> the function __init alloc_bootmem_cpumask_var().
> This is often because setup_cpu_local_masks lacks a __init 
> annotation or the annotation of alloc_bootmem_cpumask_var is wrong.
> 
> WARNING: vmlinux.o(.text+0x3c2d3): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
> The function setup_cpu_local_masks() references
> the function __init alloc_bootmem_cpumask_var().
> This is often because setup_cpu_local_masks lacks a __init 
> annotation or the annotation of alloc_bootmem_cpumask_var is wrong.
> 
> WARNING: vmlinux.o(.text+0x3c2df): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
> The function setup_cpu_local_masks() references
> the function __init alloc_bootmem_cpumask_var().
> This is often because setup_cpu_local_masks lacks a __init 
> annotation or the annotation of alloc_bootmem_cpumask_var is wrong.
> 
> WARNING: vmlinux.o(.text+0x3c2eb): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
> The function setup_cpu_local_masks() references
> the function __init alloc_bootmem_cpumask_var().
> This is often because setup_cpu_local_masks lacks a __init 
> annotation or the annotation of alloc_bootmem_cpumask_var is wrong.
> 
> Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>

applied to tip/x86/urgent, thanks Leonardo!

	Ingo
