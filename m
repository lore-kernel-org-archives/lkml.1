Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYGIM31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYGIM31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYGIM3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:29:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39926 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYGIM3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:29:19 -0400
Date: Wed, 9 Jul 2008 14:28:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH RFC 0/4] Paravirtual spinlocks
Message-ID: <20080709122852.GA30579@elte.hu>
References: <20080707190749.299430659@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707190749.299430659@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> My experiments show that using a Xen-specific lock helps guest 
> performance a bit (reduction in elapsed and system time in a kernbench 
> run), but most significantly, reduces overall physical CPU consumption 
> by 10%, and so increases overall system scalability.

that's rather impressive and looks nice, considering the fairly low 
impact.

as there were no fundamental objections in this thread i've created a 
tip/x86/paravirt-spinlocks topic branch for these patches and started 
testing them.

i based the topic branch on tip/xen-64bit, so you should be able to get 
the latest code by doing:

  git-merge tip/x86/paravirt-spinlocks

on tip/master.

	Ingo
