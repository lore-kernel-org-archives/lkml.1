Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbYAYI6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbYAYI6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbYAYI6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:58:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53697 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbYAYI6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:58:09 -0500
Date: Fri, 25 Jan 2008 09:57:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: make early_ioremap_debug early_param
Message-ID: <20080125085755.GB23708@elte.hu>
References: <1201240495.15972.44.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201240495.15972.44.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> This patch makes "early_ioremap_debug" a early parameter, because 
> "early_ioreamp/early_iounmap" is only used during early boot stage.

oops, indeed!

> @@ -215,9 +215,9 @@ static int __init early_ioremap_debug_se
>  {
>  	early_ioremap_debug = 1;
>  
> -	return 1;
> +	return 0;
>  }
> -__setup("early_ioremap_debug", early_ioremap_debug_setup);
> +early_param("early_ioremap_debug", early_ioremap_debug_setup);

thanks, applied.

	Ingo
