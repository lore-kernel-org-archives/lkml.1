Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYAJSKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYAJSKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYAJSKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:10:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46636 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYAJSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:10:38 -0500
Date: Thu, 10 Jan 2008 19:13:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
Message-ID: <20080110181315.GA1047@one.firstfloor.org>
References: <1199419890.4608.77.camel@cinder.waste.org> <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI> <1199641910.8215.28.camel@cinder.waste.org> <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> <1199906151.6245.57.camel@cinder.waste.org> <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would suggest that if you guys are really serious about memory use, try 
> to do a size-based heap thing, and do best-fit in that heap. Or just some 

iirc best fit usually also has some nasty long term fragmentation behaviour.
That is why it is usually also not used.

-Andi
