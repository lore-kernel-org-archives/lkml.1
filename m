Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbZARFGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbZARFGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZARFGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:06:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:42565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZARFGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:06:01 -0500
Message-ID: <4972B8AB.8040001@kernel.org>
Date: Sun, 18 Jan 2009 14:05:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] x86-64: Move cpu number from PDA to per-cpu and
 consolidate with 32-bit.
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <1232115396-26367-4-git-send-email-brgerst@gmail.com> <1232115396-26367-5-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232115396-26367-5-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 05:05:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
>  #endif
>  EXPORT_SYMBOL(__per_cpu_offset);
>  
> +DEFINE_PER_CPU(int, cpu_number);
> +EXPORT_PER_CPU_SYMBOL(cpu_number);

This is inside CONFIG_HAVE_SETUP_PER_CPU_AREA.  I think voyage would
be unhappy with this change.

Thanks.

-- 
tejun
