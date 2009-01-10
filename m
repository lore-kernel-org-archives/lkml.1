Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZAJXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZAJXIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZAJXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:08:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52086 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZAJXIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:08:42 -0500
Date: Sun, 11 Jan 2009 00:08:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 07/16] dma-debug: add debugfs interface
Message-ID: <20090110230826.GJ17917@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-8-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231517970-20288-8-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> +/* Global error count */
> +static u32 error_count;
> +
> +/* Global error show enable*/
> +static u32 show_all_errors __read_mostly;
> +/* Number of errors to show */
> +static u32 show_num_errors = 1;
> +
>  static u32 num_free_entries;
>  static u32 min_free_entries;

Small detail: please use native C types for non-hardware variables - 
'unsigned int', 'unsigned long', etc.

u32/u64 is typically used for variables where there is a real significance 
to the precise width of the variable: there's either a hardware or a 
user-space ABI involved.

	Ingo
