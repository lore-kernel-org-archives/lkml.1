Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYADILL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYADILL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYADIK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:10:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYADIK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:10:56 -0500
Date: Fri, 4 Jan 2008 09:10:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Improve hackbench
Message-ID: <20080104081043.GA23046@elte.hu>
References: <1199426786.3298.64.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199426786.3298.64.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> hackbench is to test Linux scheduler. The original program is at 
> http://devresources.linux-foundation.org/craiger/hackbench/src/hackbench.c 
> Based on this multi-process version, a nice person created a 
> multi-thread version. Pls. see 
> http://www.bullopensource.org/posix/pi-futex/hackbench_pth.c

great. I've uploaded your unified & improved version to:

  http://redhat.com/~mingo/cfs-scheduler/tools/hackbench.c

(i made some small changes - two warning fixes on gcc 4.2 and a default 
of 10 groups when hackbench is called without parameters, plus a 
printout.)

	Ingo
