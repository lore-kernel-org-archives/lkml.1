Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbZE3RX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbZE3RX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 13:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbZE3RXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 13:23:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZE3RXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 13:23:18 -0400
Date: Sat, 30 May 2009 19:23:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Generate per
	command manpages (and pdf/html, etc.)
Message-ID: <20090530172305.GA8985@elte.hu>
References: <tip-c1c2365acf8c044f749c0fe1ea236497e8d1718e@git.kernel.org> <20090530134601.GA12088@uranus.ravnborg.org> <20090530144712.GB31326@elte.hu> <20090530163807.GA13025@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530163807.GA13025@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > > Import Git's nice .txt => {man/html/pdf} generation machinery.
> > 
> > The .txt files were already present, so the patch is largely the 
> > infrastructure patch. The fixes to .txt files were minimal.
> 
> We do not copy Git's .txt => {man/html/pdf} support only to 
> support perfcounters.
>
> Either perfcounters use the infrastructure already present or it 
> establish a parallel infrastrucutre we can start to migrate over 
> to.
> 
> In an area where there is so little interest shown as in 
> documentation generation we do not want to have two different ways 
> to generate man pages, html etc.
> 
> IMO the ascii doc support from git is superior to what we have 
> today so I am all for replacing the current stuff. But then we 
> should do is properly and not as some perfconuter only stuff.

I still think you are misunderstanding it. It is a user-space 
tool(-set) with its own needs to install manpages and other 
documentation. Look at the code.

	Ingo
