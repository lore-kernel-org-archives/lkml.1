Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZGJN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZGJN5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZGJN5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:57:04 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:2446 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZGJN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:57:02 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mitake@dcl.info.waseda.ac.jp,
       andi@firstfloor.org, acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090710135032.GA26264@elte.hu>
References: <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp>
	 <1246870279.8143.4.camel@twins> <20090706115451.GA29715@one.firstfloor.org>
	 <20090710.214547.34380852.mitake@dcl.info.waseda.ac.jp>
	 <1247230336.7529.34.camel@twins> <20090710134307.GB23481@elte.hu>
	 <20090710134625.GB6237@nowhere>  <20090710135032.GA26264@elte.hu>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 15:56:52 +0200
Message-Id: <1247234212.7529.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 15:50 +0200, Ingo Molnar wrote:

> > I wonder if the lock_*() events should become independant from 
> > lockdep so that we don't need to always enable lockdep to get the 
> > lock events at the same time.
> > 
> > It could be a separate option.
> 
> They already should be to a large degree if CONFIG_LOCK_STAT is 
> enabled but CONFIG_PROVE_LOCKING is off. In theory :-)

Right, you don't need CONFIG_PROVE_LOCKING in order to get the
tracepoints. Also, you can always boot with prove_locking=0 or runtime
disable it using: echo 0 > /sys/module/lockdep/parameters/prove_locking



