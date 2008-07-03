Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbYGCN6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbYGCN6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYGCN6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:58:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbYGCN6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:58:39 -0400
Date: Thu, 3 Jul 2008 15:58:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make early_res_to_bootmem print out less 80 width
	chars
Message-ID: <20080703135826.GE7603@elte.hu>
References: <200806301834.59156.yhlu.kernel@gmail.com> <200807012003.11765.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807012003.11765.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

>  		struct early_res *r = &early_res[i];
> -		printk(KERN_INFO "  #%d [ %010llx - %010llx ] %16s", i,
> +		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
>  			r->start, r->end, r->name);

applied to tip/x86/unify-setup - thanks,

	Ingo
