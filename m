Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbYA1KKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbYA1KKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYA1KKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:10:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56602 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYA1KKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:10:07 -0500
Date: Mon, 28 Jan 2008 11:09:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/8] x86: fix section mismatch warnings
Message-ID: <20080128100938.GA24010@elte.hu>
References: <20080126215917.GB26651@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> The following serie of 8 patches contains:
> 
> x86: fix Section mismatch warning in srat_64.c
> => straightforward - please apply
> 
> x86: fix Section mismatch warning in mcheck/mce_64.c
> => I took some assumptions on use of notifier.
>    See comments and please review before applying
> 
> x86: fix Section mismatch warning in mcheck/mce_amd_64.c
> => Same comments as for previous patch
> 
> x86: fix Section mismatch warning in topology.c
> => Straightforward - please apply.
>    I made EXPORT of arch_register_cpu independent on config in this patch
>    as I do not see why we want to do otherwise.
> 
> x86: fix Section mismatch warning in process_*.c
> => Strightforward - please apply
> 
> x86: fix Section mismatch warning in acpi/boot.c
> => Strightforward - please apply
> 
> x86: fix Section mismatch warning in early-quirks.c
> => Strightforward - please apply
> 
> x86: fix Section mismatch warning in setup_64.c
> => Strightforward - please apply

thanks Sam, applied! Very nice series of fixes.

	Ingo
