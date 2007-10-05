Return-Path: <linux-kernel-owner+w=401wt.eu-S1764057AbXJEUcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764057AbXJEUcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762212AbXJEUcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:32:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52323 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761008AbXJEUcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:32:21 -0400
Subject: Re: SLUB performance regression vs SLAB
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: David Miller <davem@davemloft.net>, willy@linux.intel.com,
       clameter@sgi.com, nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com, suresh.b.siddha@intel.com
In-Reply-To: <470554D9.2050505@redhat.com>
References: <20071004183224.GA8641@linux.intel.com>
	 <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
	 <20071004192824.GA9852@linux.intel.com>
	 <20071004.135537.39158051.davem@davemloft.net>
	 <470554D9.2050505@redhat.com>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 22:32:00 +0200
Message-Id: <1191616320.5838.26.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-04 at 17:02 -0400, Chuck Ebbert wrote:
> On 10/04/2007 04:55 PM, David Miller wrote:
> > 
> > Anything, I do mean anything, can be simulated using small test
> > programs.
> 
> How do you simulate reading 100TB of data spread across 3000 disks,
> selecting 10% of it using some criterion, then sorting and summarizing
> the result?

Focus on the slab allocator usage, instrument it, record a trace,
generate a statistical model that matches, and write a small
programm/kernel module that has the same allocation pattern. Then verify
this statistical workload still shows the same performance difference.

Easy: no
Doable: yes



