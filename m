Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZGCKWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZGCKWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZGCKWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:22:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZGCKWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:22:44 -0400
Date: Fri, 3 Jul 2009 12:22:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703102234.GA32128@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk> <20090703064518.GA30674@elte.hu> <20090703100834.6cb241b6@lxorguk.ukuu.org.uk> <20090703091655.GB3902@elte.hu> <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk> <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Your method leads to stuff like this in a recent commit:
> 
> Which is a cut and paste of code from the originals into the 
> helper.

and this changes my points how? It's not like it's hard to fix, and 
the code is moved non-trivially anyway, it's better to have it nicer 
if we touch it anyway.

> > Also note the inconsistent printk-ing lines, mutiliated by line 
> > warps. The use of pr_warning() would solve it:
> 
> Send patches if it bugs you that much. [...]

I find that a rather flippant attitude to kernel code quality 
issues.

Also, isnt it a double standard: why should newbies be held to 
higher standards than you hold yourself to?

Please just fix problems like everyone else is expected to fix it 
too and you wont get such review feedback.

	Ingo
