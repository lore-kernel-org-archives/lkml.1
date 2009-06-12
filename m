Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbZFLRap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbZFLRap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZFLRai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:30:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZFLRah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:30:37 -0400
Date: Fri, 12 Jun 2009 19:30:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS
	requirements
Message-ID: <20090612173031.GA11233@elte.hu>
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier@gentoo.org> wrote:

> Help out arch porters who want to support perf counters by listing some
> basic requirements.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> i imagine more details would be good, but this is a starting point and
> better than nothing
> 
>  init/Kconfig          |    2 ++
>  tools/perf/design.txt |   15 +++++++++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index c649657..20f85b1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -936,6 +936,8 @@ config AIO
>  
>  config HAVE_PERF_COUNTERS
>  	bool
> +	help
> +	  See end of tools/perf/design.txt
>  
>  menu "Performance Counters"

Applied, thanks Mike! I have made a small change: i changed it from 
help text into a regular comment. We usually use help texts for 
interactive Kconfig options - but this is not one.

Thanks,

	Ingo
