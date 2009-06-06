Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZFFV6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZFFV6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZFFV6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:58:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbZFFV57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:57:59 -0400
Date: Sat, 6 Jun 2009 14:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] cpumask: introduce zalloc_cpumask_var
Message-Id: <20090606145618.e6ce8563.akpm@linux-foundation.org>
In-Reply-To: <4A2AE4AC.60805@kernel.org>
References: <4A2835D8.6040903@kernel.org>
	<200906051428.08299.rusty@rustcorp.com.au>
	<4A28B3A9.3010505@kernel.org>
	<200906052311.57762.rusty@rustcorp.com.au>
	<4A2A356B.6090102@redhat.com>
	<4A2A38B9.7030809@kernel.org>
	<4A2A3969.5030101@redhat.com>
	<4A2A4B80.1010605@kernel.org>
	<4A2AE4AC.60805@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Jun 2009 14:50:36 -0700 Yinghai Lu <yinghai@kernel.org> wrote:

>  bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
>  bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
> +bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
> +bool zalloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
>  void alloc_bootmem_cpumask_var(cpumask_var_t *mask);

ick.  cpumask_var_node_zalloc() would be better.

Yes, the other functions were incorrectly named, but that's no reason
to incorrectly name these also.

