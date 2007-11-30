Return-Path: <linux-kernel-owner+w=401wt.eu-S935821AbXK3ROu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935821AbXK3ROu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935069AbXK3ROj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:14:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934349AbXK3ROi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:14:38 -0500
Date: Fri, 30 Nov 2007 18:14:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/10] percpu: Make the asm-generic/percpu.h more
	"generic"
Message-ID: <20071130171419.GA18808@elte.hu>
References: <20071128210926.008783214@sgi.com> <20071128211526.640694725@sgi.com> <20071130111000.GA32431@elte.hu> <Pine.LNX.4.64.0711300908320.32071@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711300908320.32071@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 30 Nov 2007, Ingo Molnar wrote:
> 
> > note that this did not apply cleanly to latest x86.git. Could you 
> > double-check my merge fixups below?
> 
> This is a core change against Andrew's tree. It needs to go into mm 
> and not into the x86 tree. It is no surprise that this does not apply 
> cleanly to the x86 tree.

well since they affect the x86 tree quite heavily (and a dependent 
patchset you sent is basically for x86 only), it looked quite plausible 
to check how they fare.

	Ingo
