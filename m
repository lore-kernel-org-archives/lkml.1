Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYGZKGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYGZKGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYGZKFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:05:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYGZKFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:05:50 -0400
Date: Sat, 26 Jul 2008 12:05:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/24] OProfile: Fix build error in op_model_athlon.c
Message-ID: <20080726100537.GH25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-15-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-15-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/oprofile/op_model_athlon.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
> index 90193b1..284c456 100644
> --- a/arch/x86/oprofile/op_model_athlon.c
> +++ b/arch/x86/oprofile/op_model_athlon.c
> @@ -73,6 +73,11 @@
>  /* MSR to set the IBS control register APIC LVT offset */
>  #define IBS_LVT_OFFSET_PCI		0x1CC
>  
> +/* The function interface needs to be fixed, something like add
> +   data. Should then be added to linux/oprofile.h. */

please use standard comment style.

	Ingo
