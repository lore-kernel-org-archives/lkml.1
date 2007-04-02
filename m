Return-Path: <linux-kernel-owner+w=401wt.eu-S965808AbXDBUNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965808AbXDBUNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965796AbXDBUNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:13:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:32890 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965808AbXDBUNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:13:23 -0400
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
From: Dave Hansen <hansendc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
	 <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com>
	 <200704011246.52238.ak@suse.de>
	 <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 13:13:17 -0700
Message-Id: <1175544797.22373.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 08:37 -0700, Christoph Lameter wrote:
> You want a benchmark to prove that the removal of memory references and 
> code improves performance? 

Yes, please. ;)

I completely agree, it looks like it should be faster.  The code
certainly has potential benefits.  But, to add this neato, apparently
more performant feature, we unfortunately have to add code.  Adding the
code has a cost: code maintenance.  This isn't a runtime cost, but it is
a real, honest to goodness tradeoff.

So, let's get some kind of concrete idea what the tradeoffs are.  Is it,
400 lines of code gets us a 10% performance boost across the board, or
that 400,000 lines gets us 0.1% on one specialized benchmark?

BTW, I like the patches.  Very nice and clean.  

-- Dave

