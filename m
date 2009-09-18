Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZIRGiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZIRGiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZIRGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:38:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42872 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZIRGiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:38:02 -0400
Date: Fri, 18 Sep 2009 08:37:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [patchlet] perf_counter tools: add --input=file option to
	builtin-sched.c
Message-ID: <20090918063759.GA27091@elte.hu>
References: <1253254944.20589.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253254944.20589.11.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mike Galbraith <efault@gmx.de> wrote:

> perf_counter tools: add --input=file option to builtin-sched.c.
> 
> perf sched record passes unparsed args on to perf record, so 
> specifying an output file via perf sched record -o FILE (cmd) just 
> works.  Ergo, provide an option to specify input file as well.

Indeed, that's very useful when one keeps older (or different) traces 
around, renamed from perf.data to something else. It basically pushes 
the file based 'perf session' concept to perf sched as well.

> Also add the missing 'map' command to help.

Applied your fixes/enhancements to tip:perfcounters/core, thanks Mike!

	Ingo
