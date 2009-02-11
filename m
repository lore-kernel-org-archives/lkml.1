Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZBKIX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZBKIX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZBKIXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:23:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49357 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZBKIXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:23:49 -0500
Date: Wed, 11 Feb 2009 09:23:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf_counters: allow users to count user, kernel
	and/or hypervisor events
Message-ID: <20090211082337.GB21105@elte.hu>
References: <18834.20374.325525.248022@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18834.20374.325525.248022@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> This is available in my perfcounters.git tree master branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master
> 
>  arch/powerpc/kernel/perf_counter.c |   68 ++++++++++++++++++++++++++++++++++--
>  arch/x86/kernel/cpu/perf_counter.c |   31 ++++++++++------
>  include/linux/perf_counter.h       |   19 ++++++----
>  kernel/perf_counter.c              |   26 +++++++++++--
>  4 files changed, 117 insertions(+), 27 deletions(-)

Pulled into tip:perfcounters/core, thanks Paul!

(i think my review feedback in the previous mail can be addressed in
 separate commits)

	Ingo
