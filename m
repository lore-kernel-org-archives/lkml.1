Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbZDQPf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbZDQPf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZDQPfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:35:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZDQPfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:35:47 -0400
Date: Fri, 17 Apr 2009 17:35:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
Message-ID: <20090417153520.GA29968@elte.hu>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com> <1239951613.23397.4107.camel@laptop> <alpine.DEB.1.10.0904170941020.11877@qirst.com> <1239977776.23397.4590.camel@laptop> <alpine.DEB.1.10.0904171021360.20239@qirst.com> <1239979901.23397.4638.camel@laptop> <alpine.DEB.1.10.0904171100510.21575@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904171100510.21575@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> 
> > And a random 1us cutoff, is well, random.
> 
> Its got to be somewhere.

Sorry, that's not a rational answer that makes any sense.

Peter's point is statistics 101: please show absolute values not an 
event distribution cutoff - how much total time do we spend in the 
kernel in that workload?

Is the overhead 1%? 2%? 0.5%? And how did it change from 2.6.22 
onwards? Did it go up by 0.1%, from 1% to 1.1%? Or did the average 
go down by 0.05%, while increasing the spread of events (thus 
fooling your cutoff)?

These are very simple, very basic, very straightforward questions - 
and no straight answer was forthcoming from you. Are you not 
interested in that answer?

	Ingo
