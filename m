Return-Path: <linux-kernel-owner+w=401wt.eu-S1422668AbXCBE7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422668AbXCBE7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422657AbXCBE7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:59:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42050 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422658AbXCBE7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:59:01 -0500
Date: Thu, 1 Mar 2007 20:58:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@skynet.ie>, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
Message-Id: <20070301205826.4045eda4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703012031410.14299@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie>
	<20070301160915.6da876c5.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703011854540.5530@schroedinger.engr.sgi.com>
	<20070302035751.GA15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012001260.5548@schroedinger.engr.sgi.com>
	<20070301202917.7abe4ad8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703012031410.14299@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 20:33:04 -0800 (PST) Christoph Lameter <clameter@engr.sgi.com> wrote:

> On Thu, 1 Mar 2007, Andrew Morton wrote:
> 
> > Sorry, but this is crap.  zones and nodes are distinct, physical concepts
> > and you're kidding yourself if you think you can somehow fudge things to make
> > one of them just go away.
> > 
> > Think: ZONE_DMA32 on an Opteron machine.  I don't think there is a sane way
> > in which we can fudge away the distinction between
> > bus-addresses-which-have-the-32-upper-bits-zero and
> > memory-which-is-local-to-each-socket.
> 
> Of course you can. Add a virtual DMA and DMA32 zone/node and extract the 
> relevant memory from the base zone/node.

You're using terms which I've never seen described anywhere.

Please, just stop here.  Give us a complete design proposal which we can
understand and review.

