Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZDOXFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZDOXFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZDOXFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:05:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbZDOXE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:04:59 -0400
Date: Thu, 16 Apr 2009 01:04:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415230425.GA13744@elte.hu>
References: <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <20090415141706.096b3b64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415141706.096b3b64.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 15 Apr 2009 23:03:53 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > what can we do?
> 
> Write better patch titles?

Lets start with a patch title that you wrote:

| commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
| Author: Andrew Morton <akpm@linux-foundation.org>
| Date:   Thu Apr 9 09:50:37 2009 -0600
|
|     work_on_cpu(): rewrite it to create a kernel thread on demand
|
|     Impact: circular locking bugfix

... and to which Rusty added an impact line.

Where is the impact in that title you wrote? How could it have been 
written differently to include the impact? Why didnt you give it a 
better title? How can you expect us to do a better title if you 
yourself dont do titles with impact information?

If the impact cannot be included, can it be included elsewhere in 
the commit perhaps? If it can be included elsewhere in the commit, 
is it allowed to be summarized in a structured way, or must it stay 
mixed into a free-flowing text description?

	Ingo
