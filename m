Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbYDXGrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbYDXGrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYDXGrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 02:47:25 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59291 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbYDXGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 02:47:24 -0400
Subject: Re: [RFC][PATCH 1/2] sched: higher granularity load on 64bit
	systems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, dhaval@linux.vnet.ibm.com, vatsa@in.ibm.com,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org, efault@gmx.de
In-Reply-To: <20080423.172710.152976766.davem@davemloft.net>
References: <1208988476.2849.8.camel@lappy>
	 <20080423.172710.152976766.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 08:47:20 +0200
Message-Id: <1209019640.7115.345.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 17:27 -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu, 24 Apr 2008 00:07:56 +0200
> 
> > The below is an RFC because for some reason it regresses kbuild by 5% on
> > my machine (and more on the largesmp that are the reason for it).
> 
> This causes my 64-cpu Niagara2 box to completely hang when I run "make
> clean" on a kernel tree after a fresh bootup.
> 
> Can we just revert all of this broken code until it's sorted out? :-/
> 
> We're going on 4 days with unfixed major regressions from the
> scheduler tree merge, and these regressions make systems unusable.
> 
> This is blocking my own work, and I'm starting to lose my patience.

Yes, this is all rather embarassing - if you want a revert of the
offending patches I can spin you one, and if this isn't solved quickly
I'm afraid we'll indeed have to revert in -linus :-/

Sorry about this.

