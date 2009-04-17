Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbZDQArw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbZDQArw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760910AbZDQAoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:44:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760890AbZDQAoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:44:11 -0400
Date: Fri, 17 Apr 2009 02:43:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_defines.h
Message-ID: <20090417004352.GA1988@elte.hu>
References: <20090417001437.215128284@polymtl.ca> <20090417001637.845737169@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417001637.845737169@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* mathieu.desnoyers@polymtl.ca <mathieu.desnoyers@polymtl.ca> wrote:

>  include/linux/rcupdate.h         |  127 ------------------------------
>  include/linux/rcupdate_defines.h |  163 +++++++++++++++++++++++++++++++++++++++

Looks good to me (if Paul accepts it too), but please use the 
standard convention we use in other places for 'light' headers: 
rcupdate_types.h.

	Ingo
