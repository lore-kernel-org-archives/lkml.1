Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbYCSX3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbYCSX3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934484AbYCSWBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:01:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34480 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934494AbYCSWBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:01:31 -0400
Subject: Re: volanoMark 12% regression with 2.6.25-rc6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080318195807.GA26887@elte.hu>
References: <1205831650.3215.569.camel@ymzhang>
	 <20080318195807.GA26887@elte.hu>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 21:22:12 +0100
Message-Id: <1205871732.6487.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-18 at 20:58 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with 2.6.25-rc5, volanoMark has 12% regression with 
> > 2.6.25-rc6 on my 8-core stoakley.
> 
> could you try sched/latest please? You can pick it up via:
> 
>   http://people.redhat.com/mingo/sched-devel.git/README

Yanmin, how do you use volanomark; I got it from:

  http://www.volano.com/benchmarks.html

and am using java-1.6.0-openjdk.x86_64
I installed it /dev/shm/vmark to avoid disk io ruining anying

But I'm getting very fluctuating results, from ~43000 msgs/s to 52000
msgs/s.

This makes it very hard to 'trust' this benchmark, let alone determine a
regression.

