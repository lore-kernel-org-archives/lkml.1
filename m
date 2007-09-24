Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbXIXQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbXIXQOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbXIXQON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:14:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46202 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbXIXQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:14:12 -0400
Date: Mon, 24 Sep 2007 09:13:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (resend)
Message-Id: <20070924091310.c306df35.randy.dunlap@oracle.com>
In-Reply-To: <20070924154114.GA25368@infradead.org>
References: <1190435014.27362.16.camel@lc4eb748232119.ibm.com>
	<20070922093508.GC27827@infradead.org>
	<46F7D9FA.3090108@us.ibm.com>
	<20070924154114.GA25368@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 16:41:14 +0100 Christoph Hellwig wrote:

> On Mon, Sep 24, 2007 at 08:38:34AM -0700, David Wilder wrote:
> > >NACK, don't put code into Documentation/.  Put it into kernel as it's
> > >actually useful kernel code.  
> > 
> > Are you suggesting moving the example code into kernel? Or complaining 
> > about example code in /Documentation?
> 
> Both.  example code should be integrated with the build system so it
> gets built.

How about if we build the sample files in the Documentation/ tree?

with added Kconfig, Makefiles etc.


> > And add clone,exec and exit while you're at it.
> > 
> > Hu?  A syscall tracer sounds like a nice idea but that is not what I am 
> > trying to accomplish.  I will let Systemtap handle that.
> 
> Systemtap doesn't help anyone as it's not in the tree.  I haven't even
> asked you to provide a full system call tracing modulem but provide at
> least one that's useful for a certain use-case (looking at processes)
> instead of almost useless code.

---
~Randy
Phaedrus says that Quality is about caring.
