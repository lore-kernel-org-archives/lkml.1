Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbZD2LNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbZD2LNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZD2LNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:13:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbZD2LNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:13:08 -0400
Date: Wed, 29 Apr 2009 13:12:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/29] perfcounters: updating kerneltop documentation
Message-ID: <20090429111253.GK2373@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com> <1241002046-8832-30-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241002046-8832-30-git-send-email-robert.richter@amd.com>
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

> The documentation about the kerneltop build was outdated after
> perfstat has been implemented. This updates it.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  Documentation/perf_counter/builtin-top.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
> index dea016f..a4d00f4 100644
> --- a/Documentation/perf_counter/builtin-top.c
> +++ b/Documentation/perf_counter/builtin-top.c
> @@ -3,7 +3,7 @@
>  
>     Build with:
>  
> -     cc -O6 -Wall -c -o kerneltop.o kerneltop.c -lrt
> +     make -C Documentation/perf_counter/

These are leftover comments - i think we should just remove these 
comments (and the sample output) and move it into the 
perf_counter/Documentation/ help files?

	Ingo
