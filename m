Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbZBMQx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbZBMQx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZBMQxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:53:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZBMQxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:53:20 -0500
Date: Fri, 13 Feb 2009 17:53:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] x86: memtest: adapt log messages
Message-ID: <20090213165302.GA24299@elte.hu>
References: <20090213144600.GA6298@alberich.amd.com> <20090213145517.GD13000@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213145517.GD13000@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> +#ifdef CONFIG_X86_64
> +			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
> +			       t_start, t_start + t_size, cpu_to_be64(pattern));
> +#else
> +			printk(KERN_CONT "\n  %010llx - %010llx pattern %08x",
> +			       t_start, t_start + t_size, cpu_to_be32(pattern));
> +#endif

hm, is there really no cleaner way to do this?

	Ingo
