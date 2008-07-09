Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYGIVN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYGIVN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYGIVNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:13:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39437 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYGIVNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:13:17 -0400
Date: Wed, 9 Jul 2008 23:12:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709211256.GD4298@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <20080709192822.GB4804@elte.hu> <487525B3.90904@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487525B3.90904@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> After that is taken care of, I'll start regression testing earlier 
> compilers. I think someone mentioned that gcc-2.something was the 
> minimum required...?

i think the current official minimum is around gcc-3.2 [2.x is out of 
question because we have a few feature dependencies on gcc-3.x] - but i 
stopped using it because it miscompiles the kernel so often. 4.0 was 
really bad due to large stack footprint. The 4.3.x series miscompiles 
the kernel too in certain situations - there was a high-rising 
kerneloops.org crash recently in ext3.

So in general, 'too new' is bad because it has new regressions, 'too 
old' is bad because it has unfixed old regressions. Somewhere in the 
middle, 4.2.x-ish, seems to be pretty robust in practice.

	Ingo
