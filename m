Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbZEAPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbZEAPB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764551AbZEAO7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:59:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47709 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765294AbZEAO7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:59:20 -0400
Date: Fri, 1 May 2009 16:59:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 35/35] remove old ptemap.h includes
Message-ID: <20090501145917.GB7618@elte.hu>
References: <20090501144201.D31EF417@kernel> <20090501144255.35FCBB72@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501144255.35FCBB72@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> +++ linux-2.6.git-dave/arch/alpha/include/asm/pgtable.h	2009-04-30 15:11:13.000000000 -0700
> @@ -317,7 +317,7 @@ extern inline pte_t * pte_offset_kernel(
>  	return ret;
>  }
>  
> -#inclue <asm/ptemap.h>
> +#include <asm/ptemap.h>

that typo fix should be backmerged to earlier in the series i guess.

	Ingo
