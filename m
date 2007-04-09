Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbXDISEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbXDISEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXDISEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:04:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbXDISEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:04:23 -0400
Date: Mon, 9 Apr 2007 20:03:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Mike Galbraith <efault@gmx.de>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ten percent test
Message-ID: <20070409180356.GA17739@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org> <200704071212.57401.gene.heskett@gmail.com> <20070407180818.GB23861@elte.hu> <1175973261.6288.2.camel@Homer.simpson.net> <20070409175143.GV2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409175143.GV2986@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* William Lee Irwin III <wli@holomorphy.com> wrote:

> I strongly suggest assembling a battery of cleanly and properly 
> written, configurable testcases, and scripting a series of regression 
> tests as opposed to just randomly running kernel compiles and relying 
> on Braille.

there's interbench, written by Con (with the purpose of improving 
RSDL/SD), which does exactly that, but vanilla and SD performs quite the 
same in those tests.

it's quite hard to test interactivity, because it's both subjective and 
because even for objective workloads, things depend so much on exact 
circumstances. So the best way is to wait for actual complaints, and/or 
actual testcases that trigger badness, and victims^H^H^H^H^H testers.

(also note that often it needs _that precise_ workload to trigger some 
badness. For example make -j depends on the kind of X shell terminal 
that is used - gterm behaves differently from xterm, etc.)

	Ingo
