Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbZE3QgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbZE3QgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 12:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZE3Qfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 12:35:53 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33367 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756AbZE3Qfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 12:35:52 -0400
Date: Sat, 30 May 2009 18:38:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Generate per command manpages (and pdf/html, etc.)
Message-ID: <20090530163807.GA13025@uranus.ravnborg.org>
References: <tip-c1c2365acf8c044f749c0fe1ea236497e8d1718e@git.kernel.org> <20090530134601.GA12088@uranus.ravnborg.org> <20090530144712.GB31326@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530144712.GB31326@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > Import Git's nice .txt => {man/html/pdf} generation machinery.
> > > 
> 
> The .txt files were already present, so the patch is largely the 
> infrastructure patch. The fixes to .txt files were minimal.

We do not copy Git's .txt => {man/html/pdf} support only to
support perfcounters.
Either perfcounters use the infrastructure already present
or it establish a parallel infrastrucutre we can start
to migrate over to.

In an area where there is so little interest shown as in
documentation generation we do not want to have two different
ways to generate man pages, html etc.

IMO the ascii doc support from git is superior to what we have
today so I am all for replacing the current stuff.
But then we should do is properly and not as some perfconuter only stuff.

	Sam
