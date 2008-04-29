Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbYD2Vo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbYD2Vo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYD2VoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:44:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYD2VoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:44:17 -0400
Date: Tue, 29 Apr 2008 23:44:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: fix remove cpu_pda table patch
Message-ID: <20080429214401.GB2302@elte.hu>
References: <20080428210906.348866000@polaris-admin.engr.sgi.com> <20080428214541.GA16153@elte.hu> <48175CF8.4010105@sgi.com> <48176EA6.8060506@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48176EA6.8060506@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> -	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
> +	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);

yeah, that makes sense ... i'll reinstate your patches and check.

	Ingo
