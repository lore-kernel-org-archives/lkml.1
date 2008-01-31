Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbYAaMNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbYAaMNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764341AbYAaMNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:13:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33023 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762646AbYAaMNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:13:43 -0500
Date: Thu, 31 Jan 2008 13:13:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] x86: early_ioremap_reset fix 2
Message-ID: <20080131121322.GD12571@elte.hu>
References: <1201764964.12950.24.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201764964.12950.24.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> This patch fixes a bug of early_ioremap_reset(), which had been fixed 
> before by "convert the boot time page table to the kernels native 
> format" patch. But that patch has been reverted now.

thanks, applied. (The native-pagetables patch is in x86.git too again, 
but i'll add your patch first - just in case it needs to be reverted 
again due to some test failure.)

	Ingo
