Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYFWEaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYFWEaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 00:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYFWE36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 00:29:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46696 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYFWE36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 00:29:58 -0400
Date: Mon, 23 Jun 2008 09:59:22 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, jkenisto@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] kprobes: enable clean usage of get_kprobe
Message-ID: <20080623042922.GA4730@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <485D45C3.9060605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485D45C3.9060605@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 11:47:39PM +0530, Abhishek Sagar wrote:
> Allow clean use of get_kprobe() outside of core kprobe code. Ftrace makes use
> of get_kprobe to identify probes installed on mcount call-sites.
> 
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 1036631..04a3556 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -259,6 +259,10 @@ void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
>  struct jprobe;
>  struct kretprobe;
> 
> +static inline struct kprobe *get_kprobe(void *addr)
> +{
> +	return NULL;
> +}
>  static inline struct kprobe *kprobe_running(void)
>  {
>  	return NULL;
