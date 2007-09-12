Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbXILGUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbXILGUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 02:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbXILGUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 02:20:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:47412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756011AbXILGUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 02:20:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+IZv5kcvCIUm1jHADOpkEwNasOa6qYdYaWYZcCm4
	LBeFmwt50FfVRz
Subject: Re: [announce] CFS-devel, performance improvements
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070911200459.GA6974@elte.hu>
References: <20070911200459.GA6974@elte.hu>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 08:20:21 +0200
Message-Id: <1189578021.6493.15.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 22:04 +0200, Ingo Molnar wrote:
> fresh back from the Kernel Summit, Peter Zijlstra and me are pleased to 
> announce the latest iteration of the CFS scheduler development tree. Our 
> main focus has been on simplifications and performance - and as part of 
> that we've also picked up some ideas from Roman Zippel's 'Really Fair 
> Scheduler' patch as well and integrated them into CFS. We'd like to ask 
> people go give these patches a good workout, especially with an eye on 
> any interactivity regressions.

Initial test-drive looks good here, but I do see a regression.  First
the good news.

fairtest2 is perfect, more perfect than ever seen before in fact.  Mixed
interval sleepers/hog looks fine as well (can't say perfect due to
startup differences with the various proggies, but cpu% looks perfect).
Amarok song switch time under hefty kbuild load is fine as well.  I
haven't done heavy multimedia testing yet, but will give it a more
thorough workout later (errands).

The regression:  I see some GUI lurch, easily reproducible by running a
make -j5 and moving the mouse in a circle... perceptible (100ms or so)
lurches not present in rc5. 

	-Mike

