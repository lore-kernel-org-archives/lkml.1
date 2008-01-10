Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYAJMok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYAJMok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYAJMoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:44:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbYAJMob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:44:31 -0500
Date: Thu, 10 Jan 2008 13:44:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Move get_segment_eip() to step.c
Message-ID: <20080110124421.GB15156@elte.hu>
References: <1199950614.19760.16.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199950614.19760.16.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> get_segment_eip has similarities to convert_rip_to_linear(), and is 
> used in a similar context.  Move get_segment_eip to step.c to allow 
> easier consolidation.

thanks, applied.

> Ingo, you may want to fold this into my previous patch:
> 
> x86: begin fault_{32|64}.c unification

i'd rather keep this gradual. Unless there's a lot of flip-flop this is 
more maintainable. "use this new version for patch X" is harder (more 
error-prone) to do for a maintainer than "please merge this new gradual 
patch". We can fold too if really needed: due to bisection/build/crash 
error.

	Ingo
