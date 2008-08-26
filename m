Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYHZVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYHZVnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYHZVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:43:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47155 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYHZVnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:43:09 -0400
Date: Tue, 26 Aug 2008 14:43:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] rcu: spinlocks take an unsigned long flags
Message-ID: <20080826214307.GK6656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1219780844.6069.5.camel@brick> <20080826204534.GJ6656@linux.vnet.ibm.com> <1219783931.6069.31.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1219783931.6069.31.camel@brick>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 01:52:11PM -0700, Harvey Harrison wrote:
> On Tue, 2008-08-26 at 13:45 -0700, Paul E. McKenney wrote:
> > On Tue, Aug 26, 2008 at 01:00:44PM -0700, Harvey Harrison wrote:
> > > Noticed by sparse:
> > > kernel/rcuclassic.c:719:2: error: incompatible types in comparison expression (different signedness)
> > > kernel/rcuclassic.c:727:2: error: incompatible types in comparison expression (different signedness)
> > > kernel/rcuclassic.c: In function ‘rcu_init_percpu_data’:
> > > kernel/rcuclassic.c:719: warning: comparison of distinct pointer types lacks a cast
> > > kernel/rcuclassic.c:727: warning: comparison of distinct pointer types lacks a cast
> > 
> > This is a duplicate of http://lkml.org/lkml/2008/8/18/497, sent in
> > by Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.
> > 
> 
> Ok, what tree is it going in through, this was from today's linux-next.

Good question -- my guess would be tip/core/rcu, but either way, it
should be added somewhere.  ;-)

							Thanx, Paul
