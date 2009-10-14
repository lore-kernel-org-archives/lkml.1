Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZJNHNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZJNHNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZJNHNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:13:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42412 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbZJNHNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:13:05 -0400
Date: Wed, 14 Oct 2009 09:12:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic
	setup option
Message-ID: <20091014071217.GL784@elte.hu>
References: <20091013200702.019870576@openvz.org> <20091013201022.926793122@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013201022.926793122@openvz.org>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> In case if a system has a large number of cpus printing apics
> contents may consume a long time period.
> 
> We limit such an output by 1 apic by default. But to have an
> ability to see all apics or some part of them we introduce
> "show_lapic" setup option which allow us to limit/unlimit
> the number of APICs being dumped.
> 
> Example: apic=debug show_lapic=5, or apic=debug show_lapic=all
> 
> Also move apic_verbosity checking upper that way so helper routines
> do not need to inspect it at all.
> 
> Suggested-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/apic/io_apic.c |   47 +++++++++++++++++++++++++++--------------
>  1 file changed, 32 insertions(+), 15 deletions(-)

> +__setup("show_lapic=", setup_show_lapic);

Note: new __setup() functions need an entry in 
Documentation/kernel-parameters.txt as well.

	Ingo
