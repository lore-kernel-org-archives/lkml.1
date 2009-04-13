Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZDMXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZDMXel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZDMXeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:34:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52957 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbZDMXeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:34:31 -0400
Date: Tue, 14 Apr 2009 01:33:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/7] use smp_call_function_single() in
	arch/x86/kernel/acpi/cstate.c
Message-ID: <20090413233352.GF817@elte.hu>
References: <20090413000628.6F4B0DE11E@ozlabs.org> <20090412234555.32854fd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412234555.32854fd4.akpm@linux-foundation.org>
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

> On Mon, 13 Apr 2009 09:30:02 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Attempting to rid us of the problematic work_on_cpu().  Just use
> > smp_call_function_single() here.
> > 
> > (Includes fix from Wu Fengguang <fengguang.wu@intel.com>)
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Zhao Yakui <yakui.zhao@intel.com>
> > Cc: Wu Fengguang <fengguang.wu@intel.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> fyi, my canonical not-documented-anywhere format for atttributing the
> folded-in fixups is:
> 
> [fengguang.wu@intel.com: short description goes here]
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Zhao Yakui <yakui.zhao@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> and to include that person's Signed-off-by:, if it was provided.

It might not be documented anywhere but it is obvious hence 
self-documenting so i've been using your scheme for quite some time 
for fix foldbacks. Works very well IMO.

	Ingo
