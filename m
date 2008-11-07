Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYKGMae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYKGMae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 07:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYKGMaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 07:30:20 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:20937 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYKGMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 07:30:18 -0500
X-SourceIP: 213.46.9.244
Subject: Re: Scheduler RR, first time slice wrong?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Huber <andreas.huber@keymile.com>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <200811071020.06422.ioe-lkml@rameria.de>
References: <1225956167.4472.27.camel@chber1-10446x.ch.keymile.net>
	 <20081106074449.GC8459@elte.hu> <1225961212.7803.4190.camel@twins>
	 <200811071020.06422.ioe-lkml@rameria.de>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 13:31:02 +0100
Message-Id: <1226061062.2697.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 10:19 +0100, Ingo Oeser wrote:
> Hi Peter,
> 
> On Thursday 06 November 2008, Peter Zijlstra wrote:
> > Currently we inherit the RR time-slice from our parent. In case that is
> > init we inherit the 1s value set by default, in case its an already
> > running RR task, we inherit whatever is left.
> > 
> > Fix both these by resetting the time-slice on fork.
> 
> I remember that this MIGHT be on purpose to mitigate fork bombs.
> 
> Behaviour was, that you could starve others, if you fork, 
> do little or no work and fork again before your timeslice is over.
> 
> But I'm not sure this applies here...

Right, RT tasks have it easy starving stuff ;-)



