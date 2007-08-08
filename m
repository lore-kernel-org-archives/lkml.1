Return-Path: <linux-kernel-owner+w=401wt.eu-S936579AbXHHSTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936579AbXHHSTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbXHHSTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:19:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54891 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbXHHSTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:19:31 -0400
Subject: Re: [RFC][PATCH 4/5] introduce TASK_SIZE_OF() for all arches
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070808020354.GK30556@waste.org>
References: <20070807223300.9228E0E0@kernel>
	 <20070807223303.F720DA3E@kernel>  <20070808020354.GK30556@waste.org>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 11:19:28 -0700
Message-Id: <1186597168.22283.130.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 21:03 -0500, Matt Mackall wrote:
> On Tue, Aug 07, 2007 at 03:33:03PM -0700, Dave Hansen wrote:
> > 
> > For the /proc/<pid>/pagemap code[1], we need to able to query how
> > much virtual address space a particular task has.  The trick is
> > that we do it through /proc and can't use TASK_SIZE since it
> > references "current" on some arches.  The process opening the
> > /proc file might be a 32-bit process opening a 64-bit process's
> > pagemap file.
> 
> That seems perfectly sensible to me, but I think you'll need to bounce
> it off Andrew at least. (cc:ed)

It definitely needs a trip to linux-arch.  

-- Dave

