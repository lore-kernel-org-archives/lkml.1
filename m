Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYGaO20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYGaO20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbYGaO1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:27:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065AbYGaO1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:27:51 -0400
Message-ID: <4891CBA9.8030203@linux-foundation.org>
Date: Thu, 31 Jul 2008 09:26:49 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>	 <1199314218.4497.109.camel@cinder.waste.org>	 <20080103085239.GA10813@elte.hu>	 <1199378818.8274.25.camel@cinder.waste.org>	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>	 <1199419890.4608.77.camel@cinder.waste.org>	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>	 <1199641910.8215.28.camel@cinder.waste.org>	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>	 <1199906151.6245.57.camel@cinder.waste.org>	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>	 <1199919548.6245.74.camel@cinder.waste.org>	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>	 <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>	 <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org> <1217466583.18911.226.camel@calx>
In-Reply-To: <1217466583.18911.226.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:

> Finally getting rid of SLAB is a much trickier proposition because SLUB
> still loses in a few important corner cases.

Which corner cases? I know about the reports on the TPC issue which I guess is a result of the avoidance of queueing in the cold free case. It would be good to have a small C program (under an open source license) that shows the issue.


 

