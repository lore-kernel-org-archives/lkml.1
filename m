Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZBTW7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZBTW7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZBTW7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:59:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbZBTW7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:59:08 -0500
Date: Fri, 20 Feb 2009 23:58:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dheeraj Reddy <dheerajr@gmail.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Incorrect #ifdef in arch/x86/mm/pat.c
Message-ID: <20090220225857.GA6042@elte.hu>
References: <loom.20090220T223617-127@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20090220T223617-127@post.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0064]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dheeraj Reddy <dheerajr@gmail.com> wrote:

> Hello there,
>     The checks for reading /dev/kmem and /dev/mem in arch/x86/mm/pat.c seems to 
> be incorrect when CONFIG_STRICT_DEVMEM is set.
> Following patch corrects it.
> The check should always return 1 when CONFIG_STRICT_DEVMEM is not defined, 
> similar to what is in drivers/char/mem.c

no - see the comment in pat.c:

/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/

	Ingo
