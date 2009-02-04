Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbZBDVfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbZBDVfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZBDVfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:35:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbZBDVfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:35:41 -0500
Date: Wed, 4 Feb 2009 22:35:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, travis@sgi.com, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090204213519.GR22608@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200902041314.32277.rusty@rustcorp.com.au> <20090203190111.2ec31cef.akpm@linux-foundation.org> <200902042111.35543.rusty@rustcorp.com.au> <20090204073636.30f15339.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204073636.30f15339.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> mm/pdflush.c:
> 
>   wtf what the heck is all that stuff and who added it?  weird.
> 
>   Leave it alone I guess.  Can admins manually move kernel threads to
>   other CPUs?

they can - and there's even tools that do that (there's some -rt tools where 
you can put kernel thread priorities into a config file).

	Ingo
