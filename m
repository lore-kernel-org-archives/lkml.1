Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZIIA2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZIIA2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZIIA2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:28:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:49760 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbZIIA2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:28:46 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <4AA6579C.2080607@openwrt.org>
References: <20090906205952.GA6516@elte.hu>
	 <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu>
	 <20090908074825.GA11413@elte.hu> <1252403400.4950.81.camel@pasglop>
	 <4AA6579C.2080607@openwrt.org>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 10:28:22 +1000
Message-Id: <1252456102.26522.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The TLB is SW loaded, yes. However it should not do any misses on kernel
> space, since the whole segment is in a wired TLB entry.

Including vmalloc space ?

Ben.


