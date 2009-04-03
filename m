Return-Path: <linux-kernel-owner+w=401wt.eu-S936714AbZDCUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936714AbZDCUGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbZDCUGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:06:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43142 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbZDCUF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:05:59 -0400
Date: Fri, 3 Apr 2009 22:05:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [tip:x86/uv] x86, UV: Fix for nodes with memory and no cpus
Message-ID: <20090403200538.GA11301@elte.hu>
References: <20090330140111.GA18461@sgi.com> <tip-6a891a24e4d0056c365a90ff2d71c38fd366b0d0@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-6a891a24e4d0056c365a90ff2d71c38fd366b0d0@git.kernel.org>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Commit-ID:  6a891a24e4d0056c365a90ff2d71c38fd366b0d0
> Gitweb:     http://git.kernel.org/tip/6a891a24e4d0056c365a90ff2d71c38fd366b0d0
> Author:     Jack Steiner <steiner@sgi.com>
> AuthorDate: Mon, 30 Mar 2009 09:01:11 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 3 Apr 2009 19:49:58 +0200
> 
> x86, UV: Fix for nodes with memory and no cpus

Hm, there's a build failure regression here:

arch/x86/kernel/apic/x2apic_uv_x.c: In function ‘uv_system_init’:
arch/x86/kernel/apic/x2apic_uv_x.c:641: error: implicit declaration of function ‘node_start_pfn’

	Ingo
