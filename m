Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYI3J4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYI3J4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYI3J4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:56:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39663 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYI3J4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:56:37 -0400
Date: Tue, 30 Sep 2008 11:55:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linuxppc-dev@ozlabs.org,
       Christoph Hellwig <hch@infradead.org>, cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH] sputrace : use marker_synchronize_unregister()
Message-ID: <20080930095520.GB7557@elte.hu>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929151147.GH11245@Krystal> <200809301028.21485.jk@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809301028.21485.jk@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Kerr <jk@ozlabs.org> wrote:

> Mathieu,
> 
> > We need a marker_synchronize_unregister() before the end of exit() to
> > make sure every probe callers have exited the non preemptible section
> > and thus are not executing the probe code anymore.
> 
> Looks good - added to spufs.git.

that wont work very well as the patch relies on the new 
marker_synchronize_unregister() facility.

	Ingo
