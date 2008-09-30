Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbYI3I0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbYI3I0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYI3IZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:25:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38173 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYI3IZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:25:59 -0400
Date: Tue, 30 Sep 2008 10:25:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: IOMMU setup failures should not be KERN_ERR
Message-ID: <20080930082542.GA6657@elte.hu>
References: <1222714323-1203-1-git-send-email-ajax@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222714323-1203-1-git-send-email-ajax@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0041]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adam Jackson <ajax@redhat.com> wrote:

> The number of BIOSes that have an option to enable the IOMMU, or fix
> anything about its configuration, is vanishingly small.  There's no good
> reason to punish quiet boot for this.
> 
> Signed-off-by: Adam Jackson <ajax@redhat.com>
> ---
>  arch/x86/kernel/aperture_64.c |    6 +++---
>  include/asm-x86/gart.h        |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

applied to tip/x86/debug, thanks Adam!

	Ingo
