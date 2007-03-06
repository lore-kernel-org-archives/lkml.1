Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbXCFVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbXCFVU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXCFVU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:20:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58299 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbXCFVU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:20:56 -0500
Date: Tue, 6 Mar 2007 22:20:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306212037.GB31568@elte.hu>
References: <45ED82D9.6050204@codemonkey.ws> <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com> <20070306203712.GC21736@elte.hu> <45EDD6F1.7080100@goop.org> <20070306211105.GD26348@elte.hu> <45EDD96D.1030108@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EDD96D.1030108@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > so trying to argue as if there was no ABI imposed on Linux by hiding 
> > the Xen ABI behind paravirt_ops, and whistling into the air as if 
> > nothing happened is misguided at best.
> 
> How is the situation even slightly different with a unified hypervisor 
> ABI?

1 sane ABI instead of 4 parallel ones? It's the same difference as the 
difference between 300 system calls and 1200 system calls. Alot more 
focus, alot more integration, alot less pain. Every time i change a 
detail in Linux i have to update (and think about) 1 virtualization 
aspect - not 4 (or more).

	Ingo
