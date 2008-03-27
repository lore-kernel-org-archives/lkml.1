Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYC0D0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYC0D0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbYC0D0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:26:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbYC0D0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:26:01 -0400
Date: Wed, 26 Mar 2008 20:25:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: m.kozlowski@tuxland.pl, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64 BUG: using smp_processor_id() in preemptible
Message-Id: <20080326202502.f06938bd.akpm@linux-foundation.org>
In-Reply-To: <20080326.042516.261621639.davem@davemloft.net>
References: <alpine.LFD.1.00.0803251856450.2775@woody.linux-foundation.org>
	<200803261142.07422.m.kozlowski@tuxland.pl>
	<20080326.041626.224135350.davem@davemloft.net>
	<20080326.042516.261621639.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 04:25:16 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

>  	preempt_disable();
>  
> +	mp = &__get_cpu_var(mmu_gathers);

that's an open-coded get_cpu_var().

fwiw.  Which isn't much, IMO.  Sometimes it's nice to see things open-coded.
