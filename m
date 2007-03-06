Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbXCFEQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbXCFEQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 23:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXCFEQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 23:16:33 -0500
Received: from ozlabs.org ([203.10.76.45]:41568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXCFEQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 23:16:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17900.60167.418766.280544@cargo.ozlabs.ibm.com>
Date: Tue, 6 Mar 2007 15:16:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org>
References: <20070301101249.GA29351@skynet.ie>
	<20070301160915.6da876c5.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org>
	<45E7835A.8000908@in.ibm.com>
	<Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> The point being that in the guests, hotunplug is almost useless (for 
> bigger ranges), and we're much better off just telling the virtualization 
> hosts on a per-page level whether we care about a page or not, than to 
> worry about fragmentation.

We don't have that luxury on IBM System p machines, where the
hypervisor manages memory in much larger units than a page.  Typically
the size of memory block that the hypervisor uses to manage memory is
16MB or more -- which makes sense from the point of view that if the
hypervisor had to manage individual pages, it would end up adding a
lot more overhead than it does.

Paul.
