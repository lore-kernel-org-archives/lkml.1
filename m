Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbZATU6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbZATU6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZATU6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:58:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35408 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbZATU63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:58:29 -0500
Date: Tue, 20 Jan 2009 21:58:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       Brian Gerst <brgerst@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re:
	memory beyond4GB invisible to the system even though
	CONFIG_HIGHMEM64G=y]]
Message-ID: <20090120205820.GB19710@elte.hu>
References: <49763718.7010501@kernel.org> <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Jan 20, 2009 at 12:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > with the config
> >
> > current tip said:
> >
> >  RELOCS  arch/x86/boot/compressed/vmlinux.relocs
> > WARNING: Absolute relocations present
> > Offset     Info     Type     Sym.Value Sym.Name
> > c14d2186 00920e01   R_386_32 c1514000  __per_cpu_load
> >
> and will casue system reboot after
> 
> [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Allocating 36864 bytes of per cpu dat
> 
> YH

Cc:-ed Tejun and Brian, who are working on the pda/percpu bits.

	Ingo
