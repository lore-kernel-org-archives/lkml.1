Return-Path: <linux-kernel-owner+w=401wt.eu-S966028AbXDCRfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966028AbXDCRfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966189AbXDCRfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:35:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966028AbXDCRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:35:07 -0400
Date: Tue, 3 Apr 2007 19:35:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403173505.GD23689@one.firstfloor.org>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46128F47.2010107@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:30:47AM -0700, Ulrich Drepper wrote:
> Andi Kleen wrote:
> > Topology is dependent on the number of CPUs.
> 
> Not all of it.

What is not?

>  We might add very limited caching (for a few
> seconds) but that's as much as we can go.

Hmm, e.g. in OpenMP you would have another thread that just reads /proc/cpuinfo
in a loop and starts new threads on new CPUs?

That sounds ...... "expensive" 

The other use case in glibc I know of is the Opteron optimized
memcpy which can use different functions depending on the number of
cores.  But having a separate thread regularly rereading cpuinfo for
memcpy also sounds quite crazy.

-Andi
