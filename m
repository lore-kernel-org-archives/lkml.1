Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZAJXQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZAJXQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZAJXP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:15:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38201 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZAJXP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:15:57 -0500
Date: Sun, 11 Jan 2009 00:15:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 07/16] dma-debug: add debugfs interface
Message-ID: <20090110231531.GN17917@elte.hu>
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

> +/* debugfs dentry's for the stuff above */
> +static struct dentry *dma_debug_dent;
> +static struct dentry *global_disable_dent;
> +static struct dentry *error_count_dent;
> +static struct dentry *show_all_errors_dent;
> +static struct dentry *show_num_errors_dent;
> +static struct dentry *num_free_entries_dent;
> +static struct dentry *min_free_entries_dent;

should all be __read_mostly.

	Ingo
