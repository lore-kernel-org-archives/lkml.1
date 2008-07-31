Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYGaWMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYGaWMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbYGaWMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:12:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54056 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbYGaWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:12:41 -0400
Date: Fri, 1 Aug 2008 00:12:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function call IPIs
Message-ID: <20080731221247.GR23938@one.firstfloor.org>
References: <488FA8A9.6000005@goop.org> <20080731220825.GD23801@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731220825.GD23801@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before going into all the fine details an trying our luck in tip/master 
> QA, i'm a bit worried about hw compatibility in general though. APICs 
> have been flaky since the beginnings of times. We had erratas in the 
> area of local timer IRQs(IPIs) overlapping with IPIs, etc. - so i'd not 
> bet the farm on all APICs being able to handle a _lot_ more overlapped 
> inter-CPU IPIs than we do currently. (which basically was just three of 
> them until now, and now four with the new SMP cross-call IPIs)

At least on 64bit systems this configuration has been already tested
for years with the 8 vector TLB flush. I am not aware
of any problems caused by it. Using them on them should be fine.

So your cautious approach would only be potentially useful on older 32bit only
systems.

-Andi
