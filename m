Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXJDUzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXJDUzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbXJDUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:55:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33806
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758406AbXJDUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:55:38 -0400
Date: Thu, 04 Oct 2007 13:55:37 -0700 (PDT)
Message-Id: <20071004.135537.39158051.davem@davemloft.net>
To: willy@linux.intel.com
Cc: clameter@sgi.com, nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071004192824.GA9852@linux.intel.com>
References: <20071004183224.GA8641@linux.intel.com>
	<Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
	<20071004192824.GA9852@linux.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: willy@linux.intel.com (Matthew Wilcox)
Date: Thu, 4 Oct 2007 12:28:25 -0700

> On Thu, Oct 04, 2007 at 10:49:52AM -0700, Christoph Lameter wrote:
> > Finally: Is there some way that I can reproduce the tests on my machines?
> 
> As usual for these kinds of setups ... take a two-CPU machine, 64GB
> of memory, half a dozen fibre channel adapters, about 3000 discs,
> a commercial database, a team of experts for three months worth of
> tuning ...

Anything, I do mean anything, can be simulated using small test
programs.  Pointing at a big fancy machine with lots of storage
and disk is a passive aggressive way to avoid the real issues,
in that nobody is putting forth the effort to try and come up
with an at least publishable test case that Christoph can use to
help you guys.

If coming up with a reproducable and publishable test case is
the difference between this getting fixed and it not getting
fixed, are you going to invest the time to do that?
