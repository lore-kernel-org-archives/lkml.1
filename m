Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYIYIMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYIYIMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYIYIMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:12:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42826 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYIYIMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:12:20 -0400
Date: Thu, 25 Sep 2008 10:11:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak v2
Message-ID: <20080925081158.GA30349@elte.hu>
References: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com>
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

> use early_acpi_os_unmap_memory
> 
> v2: move unmap_memory early...
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  drivers/pci/dmar.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

since this depends on other x2apic/sparseirq changes in -tip i've 
applied it to tip/irq/sparseirq.

Jesse, any objections?

	Ingo
