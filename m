Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbYCZRY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbYCZRY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764108AbYCZRVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:21:00 -0400
Received: from usea-naimss1.unisys.com ([192.61.61.103]:4793 "EHLO
	usea-naimss1.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764098AbYCZRU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:20:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] slab: fix cache_cache bootstrap in kmem_cache_init()
Date: Wed, 26 Mar 2008 12:16:46 -0500
Message-ID: <7ECBFE60CB7F02478CDDDE40C985813A089119F0@USEA-EXCH4.na.uis.unisys.com>
In-Reply-To: <Pine.LNX.4.64.0803260927470.27909@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] slab: fix cache_cache bootstrap in kmem_cache_init()
Thread-Index: AciPXrCJR6SKuzLLTkypY9Lf6Jr3bQABUNeA
References: <Pine.LNX.4.64.0803252357330.4422@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0803252023530.20780@schroedinger.engr.sgi.com> <47E9EB77.9060909@cs.helsinki.fi> <1206535048.7468.4.camel@localhost.localdomain> <Pine.LNX.4.64.0803260927470.27909@schroedinger.engr.sgi.com>
From: "Yeisley, Dan P." <dan.yeisley@unisys.com>
To: "Christoph Lameter" <clameter@sgi.com>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, <akpm@linux-foundation.org>,
       <mel@csn.ul.ie>, <olaf@aepfle.de>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Mar 2008 17:16:46.0983 (UTC) FILETIME=[2BD3D170:01C88F65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Lameter [mailto:clameter@sgi.com]
> Sent: Wednesday, March 26, 2008 12:28
> To: Yeisley, Dan P.
> Cc: Pekka Enberg; akpm@linux-foundation.org; mel@csn.ul.ie;
> olaf@aepfle.de; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] slab: fix cache_cache bootstrap in
kmem_cache_init()
> 
> On Wed, 26 Mar 2008, Daniel Yeisley wrote:
> 
> > The only way I could get the ES7000 to boot with 2.6.24.x was with
> > memoryless nodes (or numa=off).  The list corruption I saw was due
to
> > CPU 0 not being on node 0.
> 
> What is the ES7000?
> 

The ES7000 is a server built by Unisys that supports up to 32 CPU
sockets (Xeon or Itanium).

> > I do see problems with memoryless nodes on 2.6.25-rc.  I'll post a
patch
> > for that shortly.
> 
> Another patch in addition to the one we are discussing? Or another
> revision of the patch?

I wrote another patch that affects arch/x86.  

http://lkml.org/lkml/2008/3/26/165

CPUs on memoryless nodes aren't being moved to nodes with memory.  

Dan
