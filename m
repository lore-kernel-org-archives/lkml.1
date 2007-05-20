Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbXETShl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbXETShl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbXETShe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:37:34 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:10205 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbXETShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:37:34 -0400
Date: Sun, 20 May 2007 20:36:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] local_softirq_pending storm
Message-ID: <20070520183658.GA13262@osiris.ibm.com>
References: <200705091942.22920.kernel@prachanda.hub> <200705171211.23350.kernel@prachanda.hub> <1179493277.12981.69.camel@chaos> <200705191525.28400.kernel@prachanda.hub> <1179601868.12981.127.camel@chaos> <20070520101800.GC9892@osiris.ibm.com> <1179669141.21827.22.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179669141.21827.22.camel@chaos>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 03:52:21PM +0200, Thomas Gleixner wrote:
> On Sun, 2007-05-20 at 12:18 +0200, Heiko Carstens wrote:
> > > I work out a more complex debug patch and pester you to test once I'm
> > > done.
> > 
> > I've also tons of 'NOHZ: local_softirq_pending 08' that disappear with
> > nohz=off. But I'm still running 2.6.21. Are there any patches that should
> > fix this?
> > Machine is a Lenovo T60p:
> > 
> > i686 Intel(R) Core(TM)2 CPU T7600  @ 2.33GHz GenuineIntel GNU/Linux
> 
> Hmm, that's a different problem than the 0x22 which shows up on
> hyperthreading enabled P4 systems. Are you using plip ?

No, after all it turned out that is caused by an IBM internal module.
Just ignore me, sorry for the noise :)
