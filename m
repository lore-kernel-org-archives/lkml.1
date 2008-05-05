Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbYEETBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbYEETBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762796AbYEETBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:01:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762761AbYEETB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:01:28 -0400
Message-ID: <481F5957.9010309@redhat.com>
Date: Mon, 05 May 2008 15:00:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Srinivasa Ds <srinivasa@in.ibm.com>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] make kprobe_blacklist[] static
References: <20080505182157.GG17139@cs181133002.pp.htv.fi>
In-Reply-To: <20080505182157.GG17139@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global kprobe_blacklist[] static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you for fixing,

> 
> ---
> d43075ce223623b39e6971fb670cd4e4c8628c94 diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 1e0250c..26936b1 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -79,7 +79,7 @@ static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
>   *
>   * For such cases, we now have a blacklist
>   */
> -struct kprobe_blackpoint kprobe_blacklist[] = {
> +static struct kprobe_blackpoint kprobe_blacklist[] = {
>  	{"preempt_schedule",},
>  	{NULL}    /* Terminator */
>  };
> 



-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

