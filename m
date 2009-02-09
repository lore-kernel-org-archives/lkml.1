Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZBIKqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZBIKqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZBIKqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:46:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51281 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZBIKqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:46:05 -0500
Date: Mon, 9 Feb 2009 11:45:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][stable-28] x86: microcode_amd: fix wrong handling of
	equivalent CPU id
Message-ID: <20090209104547.GM20467@elte.hu>
References: <20090209103230.GB6041@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209103230.GB6041@alberich.amd.com>
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

> Impact: fix bug resulting in non-loaded AMD microcode
> 
> mc_header->processor_rev_id is a 2 byte value. Similar is true for
> equiv_cpu in an equiv_cpu_entry -- only 2 bytes are of interest.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/microcode_amd.c |   23 ++++++-----------------
>  1 files changed, 6 insertions(+), 17 deletions(-)
> 
> This fix is already upstream.
> See
> 
>  commit 3c763fd77e66e55d029052da31df0abd9920cb1e
>  (x86: microcode_amd: fix wrong handling of equivalent CPU id)
> 
> Please apply to stable-28.

ack for the -stable backport.

	Ingo
