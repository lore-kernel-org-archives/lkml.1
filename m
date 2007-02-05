Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbXBEKqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbXBEKqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXBEKqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:46:55 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:28037 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751460AbXBEKqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:46:54 -0500
Subject: Re: v2.6.20-rt1, yum/rpm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <8355959a0702050236k14aa8c98g29fdbac2c1370def@mail.gmail.com>
References: <20070205065636.GA1652@elte.hu>
	 <8355959a0702050236k14aa8c98g29fdbac2c1370def@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 11:42:33 +0100
Message-Id: <1170672153.4672.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 16:06 +0530, Sunil Naidu wrote:
> On 2/5/07, Ingo Molnar <mingo@elte.hu> wrote:
> > i have released the v2.6.20-rt1 kernel, which can be downloaded from the
> > usual place:
> 
> Clean boot for me with 2.6.20 & 2.6.20-rt1. There isn't any error
> (like in 2.6.20-rc7-rt3).
> 
> But here is an interesting dmesg:
> 
> rcu_boost_dat: idx=1 b=0 ul=0 ub=0 boost: a=0 b=0
> rcu_boost_dat block:    0  0  0  0?
> rcu_boost_dat boost:    0! 0  0  0?
> rcu_boost_dat unlock:   0? 0  0  0?
> 
> I didn'tunderstand this with ? Am I missing anything here or please
> give some inputs.

That is Paul McKenney's RCU priority boosting stuff.

Look here:
  http://lkml.org/lkml/2007/1/24/294

