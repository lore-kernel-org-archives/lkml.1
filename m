Return-Path: <linux-kernel-owner+w=401wt.eu-S1751455AbZJGEVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbZJGEVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZJGEVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:21:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53509 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZJGEVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:21:33 -0400
Date: Tue, 6 Oct 2009 21:20:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] DEBUG_RCU_HEAD: Debug and fix racy call_rcu() users
Message-ID: <20091007042054.GE6838@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091006143727.868480435@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006143727.868480435@polymtl.ca>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 10:37:28AM -0400, Mathieu Desnoyers wrote:
> Here is a patchset, done on 2.6.30.9, which permits to detect and fix racy
> call_rcu() users.
> 
> Fix for vunmap, which happens to be one of them, is included.
> 
> Note that some false-positives might come up when call_rcu() is called on
> uninitialized struct rcu_head. The solution is, surprisingly enough, to
> initialize them.

Very cool, Mathieu!!!

I do like adding the debug-only field to struct rcu_head.  Lots of
additional places need initialization, or am I missing a trick here?

							Thanx, Paul
