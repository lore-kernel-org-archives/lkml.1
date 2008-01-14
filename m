Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbYANPsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbYANPsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYANPs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:48:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYANPs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:48:28 -0500
Date: Mon, 14 Jan 2008 16:48:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
Message-ID: <20080114154817.GA14000@elte.hu>
References: <4787436E.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4787436E.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory 
> (Xen requires GDT *and* LDT to be page-aligned). Using the page 
> allocator interface also removes the (albeit small) slab allocator 
> overhead. The same change being done for 64-bits for consistency.
> 
> Further, the Xen hypercall interface expects the LDT address to be 
> virtual, not machine.

coul dyou try this against x86.git as well? We already unified ldt.c as 
part of the paravirt patches.

	Ingo
