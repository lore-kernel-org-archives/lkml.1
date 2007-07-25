Return-Path: <linux-kernel-owner+w=401wt.eu-S1763142AbXGYMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142AbXGYMtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXGYMtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:49:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:59744 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXGYMtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:49:07 -0400
Message-ID: <46A746BF.4060301@qumranet.com>
Date: Wed, 25 Jul 2007 15:49:03 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/3] SCHED: Generic hooks for trapping task preemption
References: <11853673872732-git-send-email-avi@qumranet.com> <11853673871109-git-send-email-avi@qumranet.com>
In-Reply-To: <11853673871109-git-send-email-avi@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 25 Jul 2007 15:49:05 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>  /**
>   * prepare_task_switch - prepare to switch tasks
>   * @rq: the runqueue preparing to switch
> @@ -1687,6 +1746,7 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
>   */
>  static inline void prepare_task_switch(struct rq *rq, struct task_struct *next)
>  {
> +	fire_sched_out_preempt_hooks(current);
>   

This wants an extra arg, 'next', of course.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

