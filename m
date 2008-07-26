Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYGZJ4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYGZJ4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYGZJz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:55:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYGZJz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:55:56 -0400
Date: Sat, 26 Jul 2008 11:55:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/24] x86/oprofile: Renaming athlon_*() into op_amd_*()
Message-ID: <20080726095540.GC25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-7-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-7-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> -struct op_x86_model_spec const op_athlon_spec = {
> +struct op_x86_model_spec const op_amd_spec = {
>  	.init = op_amd_init,
>  	.exit = op_amd_exit,
>  	.num_counters = NUM_COUNTERS,
>  	.num_controls = NUM_CONTROLS,
> -	.fill_in_addresses = &athlon_fill_in_addresses,
> -	.setup_ctrs = &athlon_setup_ctrs,
> -	.check_ctrs = &athlon_check_ctrs,
> -	.start = &athlon_start,
> -	.stop = &athlon_stop,
> -	.shutdown = &athlon_shutdown
> +	.fill_in_addresses = &op_amd_fill_in_addresses,
> +	.setup_ctrs = &op_amd_setup_ctrs,
> +	.check_ctrs = &op_amd_check_ctrs,
> +	.start = &op_amd_start,
> +	.stop = &op_amd_stop,
> +	.shutdown = &op_amd_shutdown
>  };

minor style comment: while we are at touching these initializers, could 
you also do a followup cleanup patch that uses the standard initializer 
style of arch/x86 that have the initializer values aligned vertically? 

Sample:

static const struct file_operations ptdump_fops = {
	.open		= ptdump_open,
	.read		= seq_read,
	.llseek		= seq_lseek,
	.release	= single_release,
};

Thanks,

	Ingo
