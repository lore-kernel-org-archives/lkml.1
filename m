Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbZIHWJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbZIHWJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZIHWJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:09:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41744 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZIHWJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:09:40 -0400
Date: Tue, 8 Sep 2009 15:09:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: Odd Kconfig output..
Message-ID: <20090908220943.GJ6753@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <12284.1252155974@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12284.1252155974@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 09:06:14AM -0400, Valdis.Kletnieks@vt.edu wrote:
> Saw this while doing  a 'make oldconfig' moving from -mmotm0827 to -mmotm0903:
> 
> RCU Implementation
> > 1. Tree-based hierarchical RCU (TREE_RCU)
>   2. Preemptable tree-based hierarchical RCU (TREE_PREEMPT_RCU) (NEW)
> choice[1-2]: ?
> 
> There is no help available for this kernel option.
> Prompt: RCU Implementation
>   Defined at init/Kconfig:329
>   Location:
>     -> General setup
>       -> RCU Subsystem
>   Selected by: m [=m]
> 
> Where did that 'Selected by:' come from? Or is that just an artifact of
> the way Kconfig implements 'choice'?

Many of the architectures use a "select" clause for RCU, usually
selecting CLASSIC_RCU.  Could that be the issue?

							Thanx, Paul
