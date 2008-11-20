Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYKTL6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYKTL6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYKTL6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:58:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbYKTL6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:58:41 -0500
Date: Thu, 20 Nov 2008 12:58:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
Message-ID: <20081120115830.GA20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com> <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
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


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> --- a/init/main.c
> +++ b/init/main.c
> @@ -63,6 +63,7 @@
>  #include <linux/signal.h>
>  #include <linux/idr.h>
>  #include <linux/ftrace.h>
> +#include <linux/memleak.h>

small request: could you please move this #include line up by 5-7 
lines so that it auto-merges fine with the ftrace-next tree?

	Ingo
