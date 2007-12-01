Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXLATuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXLATuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXLATt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:49:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:22226 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbXLATtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:49:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=l1jXJc2jljPE/TkSEKrnMHyoAn/POC9twWvAOlYamuIs+CCa3OfSqmrKy7dAc2oZVj0W0xBk4fvLSOl+BwZri5gvqdLKqm724LLBau3drw0wMJzpYI+0YTGpiy6R7LvyA/3RBnFyyqmV1rbZzTUIhJZ7rA9DAXzK6d66+NLdZcM=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.24-rc3-git4 build warnings
Date: Sat, 1 Dec 2007 19:49:46 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200711291419.49261.chris2553@googlemail.com> <20071201193636.GC15974@stusta.de>
In-Reply-To: <20071201193636.GC15974@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712011949.46386.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007, Adrian Bunk wrote:
> On Thu, Nov 29, 2007 at 02:19:49PM +0000, Chris Clayton wrote:
> > Hi,
> >
> > I've just built 2.6.24-rc3-git4 and got the following two warnings.
> >
> >   LD      .tmp_vmlinux1
> >   KSYM    .tmp_kallsyms1.S
> >   AS      .tmp_kallsyms1.o
> >   LD      .tmp_vmlinux2
> >   KSYM    .tmp_kallsyms2.S
> >   AS      .tmp_kallsyms2.o
> >   LD      vmlinux.o
> >   MODPOST vmlinux.o
> > WARNING: vmlinux.o(.text+0x90b6): Section mismatch: reference to
> > .init.text:cache_remove_shared_cpu_map (between 'free_cache_attributes'
> > and 'show_level')
> > WARNING: vmlinux.o(.init.text+0x143bd): Section mismatch: reference to
> > .exit.text:cpufreq_stats_free_table (between 'cpufreq_stat_cpu_callback'
> > and 'cpufreq_stats_init')
> >...
>
> You seem to be using gcc 3.3 or 3.4.
>

Yes, it's 3.3.6. README in the top-level kernel source directory says "Make 
sure you have at least gcc 3.2 available", so that should be OK, shouldn't 
it?

> I'll send patches for these.
>

Thanks

> > Chris
>
> cu
> Adrian

Chris

-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
