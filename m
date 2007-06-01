Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbXFAF4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbXFAF4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXFAFzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:55:50 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39182
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXFAFzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:55:49 -0400
Date: Thu, 31 May 2007 22:55:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Tejun Heo <htejun@gmail.com>
cc: Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
In-Reply-To: <465F9197.7060002@gmail.com>
Message-ID: <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm>
References: <18006.38689.818186.221707@notabene.brown> 
 <18010.12472.209452.148229@notabene.brown>  <20070528094358.GM25091@agk.fab.redhat.com>
  <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> 
 <20070529220500.GA6513@agk.fab.redhat.com> 
 <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> 
 <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com>
 <465F9197.7060002@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Tejun Heo wrote:

> but one
> thing we should bear in mind is that harddisks don't have humongous
> caches or very smart controller / instruction set.  No matter how
> relaxed interface the block layer provides, in the end, it just has to
> issue whole-sale FLUSH CACHE on the device to guarantee data ordering on
> the media.

if you are talking about individual drives you may be right for the moment 
(but 16M cache on drives is a _lot_ larger then people imagined would be 
there a few years ago)

but when you consider the self-contained disk arrays it's an entirely 
different story. you can easily have a few gig of cache and a complete OS 
pretending to be a single drive as far as you are concerned.

and the price of such devices is plummeting (in large part thanks to Linux 
moving into this space), you can now readily buy a 10TB array for $10k 
that looks like a single drive.

David Lang
