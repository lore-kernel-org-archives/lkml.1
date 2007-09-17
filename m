Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXIQT5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXIQT5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbXIQT5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:57:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43654 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbXIQT5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:57:23 -0400
Date: Mon, 17 Sep 2007 21:56:15 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [PATCH] Configurable reclaim batch size
Message-ID: <20070917215615.685a5378@lappy>
In-Reply-To: <Pine.LNX.4.64.0709171053040.26860@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709141519230.14894@schroedinger.engr.sgi.com>
	<1189812002.5826.31.camel@lappy>
	<Pine.LNX.4.64.0709171053040.26860@schroedinger.engr.sgi.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 10:54:59 -0700 (PDT) Christoph Lameter
<clameter@sgi.com> wrote:

> On Sat, 15 Sep 2007, Peter Zijlstra wrote:
> 
> > It increases the lock hold times though. Otoh it might work out with the
> > lock placement.
> 
> Yeah may be good for NUMA.

Might, I'd just like a _little_ justification for an extra tunable.

> > Do you have any numbers that show this is worthwhile?
> 
> Tried to run AIM7 but the improvements are in the noise. I need a tests 
> that really does large memory allocation and stresses the LRU. I could 
> code something up but then Lee's patch addresses some of the same issues.
> Is there any standard test that shows LRU handling regressions?

hehe, I wish. I was just hoping you'd done this patch as a result of an
actual problem and not a hunch.
