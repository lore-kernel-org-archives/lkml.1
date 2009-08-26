Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZHZWjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZHZWjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZHZWjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:39:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38936 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZHZWjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:39:42 -0400
Date: Wed, 26 Aug 2009 15:39:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove lockdep annotations from RCU's
	_notrace() API members
Message-ID: <20090826223943.GH6752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090826015337.GA18904@linux.vnet.ibm.com> <tip-06e799764eb7c2e4640888d438c3524d756613e1@git.kernel.org> <20090826084938.GA5023@elte.hu> <20090826173318.GC6752@linux.vnet.ibm.com> <20090826183954.GE13632@elte.hu> <20090826221034.GA31586@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826221034.GA31586@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 12:10:34AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > and booted it - and that did not produce any lockups. So you might 
> > not be able to reproduce it :-/ I've re-merged core/rcu into 
> > tip/master, maybe my tests can find another config that reproduces 
> > the crash better. Please disregard this bugreport until i've found 
> > that one.
> 
> it's in iteration #300 now and still no crash - so i think we can 
> disregard this. This means the lockup got fixed for good :)

Woo-hoo!!!  ;-)

And thanks to Lai and Mathieu for pointing me in the right direction!

							Thanx, Paul
