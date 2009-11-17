Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZKQMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZKQMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZKQMxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:53:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZKQMxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:53:18 -0500
Date: Tue, 17 Nov 2009 13:53:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: Re: [PATCH 1/4] perf bench: Add mem-memcpy.c:memcpy() benchmark
Message-ID: <20091117125315.GA22668@elte.hu>
References: <20091117112148.GA32578@elte.hu>
 <1258458153-25700-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258458153-25700-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, it fails to build on 32-bit systems, with:

bench/mem-memcpy.c: In function 'bench_mem_memcpy':
bench/mem-memcpy.c:118: error: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'

	Ingo
