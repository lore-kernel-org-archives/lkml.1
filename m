Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035Ab0ADAIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0ADAIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623Ab0ADAIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:08:50 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56124 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0ADAIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:08:50 -0500
Date: Mon, 4 Jan 2010 05:37:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-ID: <20100104000752.GC16187@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091229182743.GB12533@balbir.in.ibm.com>
 <20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-04 08:51:08]:

> On Tue, 29 Dec 2009 23:57:43 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Hi, Everyone,
> > 
> > I've been working on heuristics for shared page accounting for the
> > memory cgroup. I've tested the patches by creating multiple cgroups
> > and running programs that share memory and observed the output.
> > 
> > Comments?
> 
> Hmm? Why we have to do this in the kernel ?
>

For several reasons that I can think of

1. With task migration changes coming in, getting consistent data free of races
is going to be hard.
2. The cost of doing it in the kernel is not high, it does not impact
the memcg runtime, it is a request-response sort of cost.
3. The cost in user space is going to be high and the implementation
cumbersome to get right.
 
-- 
	Balbir
