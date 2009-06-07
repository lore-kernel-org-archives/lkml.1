Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZFGOBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZFGOBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZFGOBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:01:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZFGOBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:01:25 -0400
Date: Sun, 7 Jun 2009 16:01:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Figo.zhang" <figo1802@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Tigran Aivazian <tigran@veritas.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]X86:microcode: fix vfree()
Message-ID: <20090607140113.GI12088@elte.hu>
References: <1244351929.3355.13.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244351929.3355.13.camel@myhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Figo.zhang <figo1802@gmail.com> wrote:

>  
> vfree() does it's own 'NULL' check,so no need for check before
> calling it.

looks good, but:

 s/it's/its/
 s/check,so/check, so/

and:

>  static void free_equiv_cpu_table(void)
>  {
> -	if (equiv_cpu_table) {
> -		vfree(equiv_cpu_table);
> -		equiv_cpu_table = NULL;
> -	}
> +	vfree(equiv_cpu_table);
> +	equiv_cpu_table = NULL;
> +	
>  }

stray newline and tab.

	Ingo
