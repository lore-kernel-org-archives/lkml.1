Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbXJZRyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbXJZRyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXJZRye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:54:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48643 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752003AbXJZRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:54:33 -0400
Date: Fri, 26 Oct 2007 10:54:31 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
Message-Id: <20071026105431.77d56253.pj@sgi.com>
In-Reply-To: <1193420627.5032.46.camel@localhost>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
	<20071025230409.81f20ed3.pj@sgi.com>
	<alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
	<20071026025634.0f32e1e2.pj@sgi.com>
	<20071026101805.df3ebfda.pj@sgi.com>
	<1193420627.5032.46.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Will it handle the case of MPOL_INTERLEAVE policy on a shm segment that
> is mapped by tasks in different, possibly disjoint, cpusets.  Local
> allocation does, and my patch does.  That was one of the primary
> goals--to address an issue that Christoph has with shared policies.
> cpusets really muck these up!

It probably won't handle that.  I don't get along too well with shmem.

Can you to an anti-shmem bigot how MPOL_INTERLEAVE should work with
shmem segments mapped in diverse ways by different tasks in different
cpusets?  What would be the key attribute(s) of a proper solution?
Maybe if we keep it simple enough, I can avoid mucking it up too much
this time around.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
