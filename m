Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbYARMwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbYARMwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYARMwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:52:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121AbYARMwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:52:00 -0500
Date: Fri, 18 Jan 2008 13:51:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/4] x86: msr for AMD Fam 10h mmio
Message-ID: <20080118125142.GN11044@elte.hu>
References: <200801141331.45898.yinghai.lu@sun.com> <478CD46D.5080104@zytor.com> <200801151354.02859.yinghai.lu@sun.com> <200801151356.27779.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801151356.27779.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> +/* Fam 10h MSRs */
> +#define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
> +#define FAM10H_MMIO_CONF_ENABLE		(1<<0)
> +#define FAM10H_MMIO_CONF_BUSRANGE_MASK	0xf
> +#define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
> +#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
> +#define FAM10H_MMIO_CONF_BASE_SHIFT	20

i've applied this patch to x86.git - but the other patches should go via 
Greg and/or -mm i suspect?

	Ingo
