Return-Path: <linux-kernel-owner+w=401wt.eu-S2992763AbXDDIua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992763AbXDDIua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992765AbXDDIu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:50:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43199 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992763AbXDDIu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:50:28 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 04:50:28 EDT
Date: Wed, 4 Apr 2007 10:50:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, adobriyan@sw.ru, rusty@rustcorp.com.au
Subject: Re: + simplify-kallsyms_lookup.patch added to -mm tree
Message-ID: <20070404085018.GB2521@elte.hu>
References: <200704040010.l340AQt1007291@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704040010.l340AQt1007291@shell0.pdx.osdl.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> diff -puN kernel/lockdep.c~simplify-kallsyms_lookup kernel/lockdep.c
> --- a/kernel/lockdep.c~simplify-kallsyms_lookup
> +++ a/kernel/lockdep.c
> @@ -340,10 +340,7 @@ static const char *usage_str[] =
>  
>  const char * __get_key_name(struct lockdep_subclass_key *key, char *str)
>  {
> -	unsigned long offs, size;
> -	char *modname;
> -
> -	return kallsyms_lookup((unsigned long)key, &size, &offs, &modname, str);
> +	return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
>  }

thanks,

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
