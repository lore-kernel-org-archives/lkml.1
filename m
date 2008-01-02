Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbYABQJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbYABQJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYABQJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:09:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35248 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbYABQJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:09:34 -0500
Date: Wed, 2 Jan 2008 17:09:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: begin fault_{32|64}.c unification
Message-ID: <20080102160923.GC21046@elte.hu>
References: <1199277984.6323.66.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199277984.6323.66.camel@brick>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Move X86_32 only get_segment_eip to X86_64
> Move X86_64 only is_errata93 to X86_32
> 
> Change X86_32 loop in is_prefetch to highlight the differences between 
> them.  Fold the logic from __is_prefetch in as well on X86_32.

thanks, applied.

	Ingo
