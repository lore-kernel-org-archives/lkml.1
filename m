Return-Path: <linux-kernel-owner+w=401wt.eu-S1766837AbXDSQJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766837AbXDSQJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766841AbXDSQJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:09:48 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47253 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766837AbXDSQJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:09:47 -0400
X-IronPort-AV: i="4.14,428,1170662400"; 
   d="scan'208"; a="52654675:sNHT16166605"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: chuck.lever@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070419155046.GR24044@iucha.net>
References: <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
	 <20070417223738.8f49a39f.akpm@linux-foundation.org>
	 <20070418123842.GF24044@iucha.net>
	 <1176902131.6796.62.camel@heimdal.trondhjem.org>
	 <20070418134225.GG24044@iucha.net>
	 <1176905506.6796.84.camel@heimdal.trondhjem.org>
	 <20070419015232.GO24044@iucha.net>
	 <1176950713.6422.95.camel@heimdal.trondhjem.org>
	 <462786C9.7090405@oracle.com>
	 <1176995848.6663.1.camel@heimdal.trondhjem.org>
	 <20070419155046.GR24044@iucha.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 19 Apr 2007 12:09:42 -0400
Message-Id: <1176998982.6663.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 19 Apr 2007 16:09:49.0512 (UTC) FILETIME=[27F3E480:01C7829D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 10:50 -0500, Florin Iucha wrote:
> On Thu, Apr 19, 2007 at 11:17:28AM -0400, Trond Myklebust wrote:
> > On Thu, 2007-04-19 at 11:12 -0400, Chuck Lever wrote:
> > > Perhaps instead of looking at the number of bytes sent, the logic in the 
> > > last hunk of this patch should check which queue the request is sitting on.
> > 
> > ??? It would be a bug for the request to be sitting on _any_ queue when
> > it enters xprt_transmit().
> > 
> > Here is the patch that I'm currently testing.
> 
> Trond,
> 
> What is the set of patches that are you testing?  I'd like to give
> that a spin tonight as well.
> 
> It is possible that what makes my configuration more susceptible
> to the problem is the fact that the client significantly overpowers
> the server: Athlon x2 4200+ with 2Gb of RAM for the client vs. PIII
> 1Ghz 512 MB RAM for the server.  They both have gigabit ethernet
> and both NICs and the switch support jumbo frames.
> 
> Regards,
> florin
> 

See
   http://client.linux-nfs.org/Linux-2.6.x/2.6.21-rc7/

I'm giving the first 5 patches of that series (i.e.
linux-2.6.21-001-cleanup_unstable_write.dif to
linux-2.6.21-005-fix_nfsv4_resend.dif) an extra beating since those are
the ones that I feel should go into 2.6.21 final in order to fix the
read/write regressions that have been reported. They should be identical
to the patches that I posted on lkml in the past 3 days.

Please feel free to grab them and give them a test.

Cheers
  Trond
