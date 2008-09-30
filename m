Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYI3LbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYI3LbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYI3LbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:31:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYI3LbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:31:09 -0400
Date: Tue, 30 Sep 2008 13:30:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: cbe-oss-dev@ozlabs.org, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Cbe-oss-dev] [PATCH] sputrace : use
	marker_synchronize_unregister()
Message-ID: <20080930113020.GE21367@elte.hu>
References: <48E08B05.7030802@cn.fujitsu.com> <200809301028.21485.jk@ozlabs.org> <20080930095520.GB7557@elte.hu> <200809302122.36117.jk@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809302122.36117.jk@ozlabs.org>
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


* Jeremy Kerr <jk@ozlabs.org> wrote:

> Ingo,
> 
> > that wont work very well as the patch relies on the new
> > marker_synchronize_unregister() facility.
> 
> d'oh, right you are. Should I leave this in your hands to merge?

would be nice if you could give your Acked-by for the sputrace bits, 
then we can merge it. It's a oneliner so it shouldnt cause merging 
trouble in linux-next.

	Ingo
