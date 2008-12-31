Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYLaLG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYLaLG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYLaLGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:06:49 -0500
Received: from ozlabs.org ([203.10.76.45]:34409 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbYLaLGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:06:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH -tip] cpumask: fix compile error in kernel/irq/proc.c
Date: Wed, 31 Dec 2008 21:36:40 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <495B345A.5080302@cn.fujitsu.com>
In-Reply-To: <495B345A.5080302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812312136.40502.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 19:29:06 Li Zefan wrote:
> diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
> index 2abd3a7..5a5ac60 100644
> --- a/kernel/irq/proc.c
> +++ b/kernel/irq/proc.c
> @@ -111,7 +111,7 @@ static ssize_t default_affinity_write(struct file *file,
>  	if (err)
>  		goto out;
>  
> -	if (!is_affinity_mask_valid(new_value)) {
> +	if (!is_affinity_mask_valid(*new_value)) {
>  		err = -EINVAL;
>  		goto out;
>  	}

This looks like one for Mike: I have *new_value in the cpumask tree.

Mike?

Thanks,
Rusty.
