Return-Path: <linux-kernel-owner+w=401wt.eu-S1761056AbYHAVLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761056AbYHAVLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760751AbYHAVJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:09:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48517 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760748AbYHAVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:09:30 -0400
Date: Fri, 1 Aug 2008 14:09:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu classic: new algorithm for
	callbacks-processing
Message-ID: <20080801210929.GF14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4844BE83.5010401@cn.fujitsu.com> <20080608151844.GA18751@linux.vnet.ibm.com> <485F17B2.5010700@cn.fujitsu.com> <20080623091349.GK22569@linux.vnet.ibm.com> <48708F23.2080702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48708F23.2080702@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 05:23:47PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> 
> > 
> > You tried this without your changes and it passed, correct?
> > 
> > Never forget to test the base kernel.  ;-)
> > 
> 
> Thanks, but I make some mistake here.
> 
> I tested the base kernel, no bug occurred.
> So I try to find out bugs in my changes in 2 weeks.
> 
> I added debug codes and these codes showed all processing
> are right and no callback broke its grace period
> but the bug still occurred.
> 
> When I was puzzled after 2 weeks, I looked back the base
> kernel that I had tested, and I found that I forget to set
> CONFIG_NO_HZ=y.
> 
> Then I set CONFIG_NO_HZ=y in the base kernel, and the bug
> occurred. It's exactly as the bug when my patch applied.
> 
> I have reported this bug here:
> http://lkml.org/lkml/2008/7/3/24

Hello, Jiangshan,

Does Gautham's patch (http://lkml.org/lkml/2008/6/27/9) help?

							Thanx, Paul
