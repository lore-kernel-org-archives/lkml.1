Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXCEN5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXCEN5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932713AbXCEN5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:57:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbXCEN5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:57:07 -0500
Date: Mon, 5 Mar 2007 14:48:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Avi Kivity <avi@qumranet.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305134854.GA31542@elte.hu>
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com> <20070305142820.GD22829@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305142820.GD22829@bingen.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> The problem is not the syscall instruction, but some problem with the 
> way the vDSO mapping is set up with CONFIG_PARAVIRT that broke older 
> glibc.

the problem is that CONFIG_PARAVIRT silently turns off 
CONFIG_COMPAT_VDSO, which of course breaks 'old' glibc. This too is a 
must-have fix for v2.6.21.

	Ingo
