Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXIQLrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXIQLrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXIQLrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:47:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXIQLrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:47:23 -0400
Date: Mon, 17 Sep 2007 13:47:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: Rob Hussey <robjhussey@gmail.com>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070917114714.GA32532@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <200709170712.03679.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709170712.03679.edt@aei.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0080]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ed Tomlinson <edt@aei.ca> wrote:

> I gather this was with the complete -ck patchset?  It would be 
> interesting to see if just SD performed as well.  If it does, CFS 
> needs more work. if not there are other things in -ck that really do 
> improve performance and should be looked into.

also see:

   http://lkml.org/lkml/2007/9/17/172

i think at least part of the differences is due to the different 
sched_clock() accuracy and performance in v2.6.22-ck versus v2.6.23-cfs.

	Ingo
