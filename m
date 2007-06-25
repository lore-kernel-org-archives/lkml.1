Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbXFYSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbXFYSpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXFYSpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:45:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:10377 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXFYSpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ki2gDJbtYgYu1wd30bW28tHGSzOSIGntpLfs50/22B0aSJr2lhcoVHgpy0/sk0SKY5P6nyGW969MqLXRL9RiI/uTvN7ElJxawsChenBo1pZ5fyckeI+SoT7tDXLAoSBoeEcEBy8ZgjGecyrK3kXsWXRkfIMNRrbULnQ+//c9IUs=
Message-ID: <43c301fe0706251145q3249ddcar3e723ae7db8d6ebc@mail.gmail.com>
Date: Mon, 25 Jun 2007 11:45:12 -0700
From: "Takayoshi Kochi" <takayoshi.kochi@gmail.com>
To: linux-mm@kvack.org
Subject: Re: NUMA BOF @OLS
Cc: "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Arnd Bergmann" <arnd@arndb.de>
In-Reply-To: <200706221214.58823.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706211316150.9220@schroedinger.engr.sgi.com>
	 <200706220112.51813.arnd@arndb.de>
	 <Pine.LNX.4.64.0706211844420.11754@schroedinger.engr.sgi.com>
	 <200706221214.58823.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'll host another mm-related BOF at OLS:

Discussion for the Future of Linux Memory Management
Saturday Jun 30th, 2007 14:45-15:30

I'll share some experiences with the MM-related real world issues there.
Anyone who have something to pitch in is welcome.
Please contact me or grab me at OLS.

Any topics spilled out of NUMA BOF are welcome!


2007/6/22, Arnd Bergmann <arnd@arndb.de>:
> On Friday 22 June 2007, Christoph Lameter wrote:
> >
> > On Fri, 22 Jun 2007, Arnd Bergmann wrote:
> >
> > > - Interface for preallocating hugetlbfs pages per node instead of system wide
> >
> > We may want to get a bit higher level than that. General way of
> > controlling subsystem use on nodes. One wants to restrict the slab
> > allocator and the kernel etc on nodes too.
> >
> > How will this interact with the other NUMA policy specifications?
>
> I guess that's what I'd like to discuss at the BOF. I frequently
> get requests from users that need to have some interface for it:
> Application currently break if they try to use /proc/sys/vm/nr_hugepages
> in combination with numactl --membind.
>
> > > - architecture independent in-kernel API for enumerating CPU sockets with
> > > multicore processors (not sure if that's the same as your existing subject).
> >
> > Not sure what you mean by this. We already have a topology interface and
> > the scheduler knows about these things.
>
> I'm not referring to user interfaces or scheduling. It's probably not really
> a NUMA topic, but we currently use the topology interfaces for enumerating
> sockets on systems that are not really NUMA. This includes stuff like
> per-socket
>  * cpufreq settings (these have their own logic currently)
>  * IOMMU
>  * performance counters
>  * thermal management
>  * local interrupt controller
>  * PCI/HT host bridge
>
> If you have a system with multiple CPUs in one socket and either multiple
> sockets in one NUMA node or no NUMA at all,  you have no way of properly
> enumerating the sockets.  I'd like to discuss what such an interface
> would need to look like to be useful for all architectures.
>
>         Arnd <><
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Takayoshi Kochi
