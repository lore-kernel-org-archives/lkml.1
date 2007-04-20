Return-Path: <linux-kernel-owner+w=401wt.eu-S1767106AbXDTNhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767106AbXDTNhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767103AbXDTNhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:37:34 -0400
Received: from mx2.netapp.com ([216.240.18.37]:3005 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767106AbXDTNhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:37:33 -0400
X-IronPort-AV: i="4.14,432,1170662400"; 
   d="scan'208"; a="52906477:sNHT295379651"
Subject: Re: Success! Was: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series
	of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: chuck.lever@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070420133028.GA24044@iucha.net>
References: <1176905506.6796.84.camel@heimdal.trondhjem.org>
	 <20070419015232.GO24044@iucha.net>
	 <1176950713.6422.95.camel@heimdal.trondhjem.org>
	 <462786C9.7090405@oracle.com>
	 <1176995848.6663.1.camel@heimdal.trondhjem.org>
	 <20070419155046.GR24044@iucha.net>
	 <1176998982.6663.10.camel@heimdal.trondhjem.org>
	 <20070419195844.GT24044@iucha.net>
	 <1177018242.6628.10.camel@heimdal.trondhjem.org>
	 <20070419214931.GX24044@iucha.net>  <20070420133028.GA24044@iucha.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Fri, 20 Apr 2007 09:37:30 -0400
Message-Id: <1177076250.6364.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 20 Apr 2007 13:37:37.0884 (UTC) FILETIME=[0F7DC9C0:01C78351]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 08:30 -0500, Florin Iucha wrote:
> On Thu, Apr 19, 2007 at 04:49:31PM -0500, Florin Iucha wrote:
> > On Thu, Apr 19, 2007 at 05:30:42PM -0400, Trond Myklebust wrote:
> > > > I'm far from the machine right now, so I will do some more tests
> > > > tonight, but right now, the new patchset is not good.  What is the
> > > > difference between reverting the patch you sent yesterday and your
> > > > current fifth patch?  I assume the other four are identical, right?
> > > 
> > > The only difference is the way in which we handle retries of an NFSv4
> > > request: the new patch disconnects if and only if a timeout has
> > > occurred, or the server sends us garbage.
> > 
> > I have to mention that I rebased to the head of the tree
> > (895e1fc7226e6732bc77138955b6c7dfa279f57a) before applying your
> > patches, in order to test what I expect the official tree to be.
> > 
> > Tonight I'll test this kernel once more, then go back to 21-rc7 and
> > apply your 5 patches and re-test.
> 
> It passed big-copy, and the copy run from the gnome-session while I
> did my morning light browsing, email reading, etc.
> 
> kernel:
>    895e1fc7226e6732bc77138955b6c7dfa279f57a
> 
> patches:
>    linux-2.6.21-001-cleanup_unstable_write.dif
>    linux-2.6.21-002-defer_clearing_pg_writeback.dif
>    linux-2.6.21-003-fix_desynchronised_ncommit.dif
>    linux-2.6.21-004-fix_nfs_set_page_dirty.dif
>    linux-2.6.21-005-fix_nfsv4_resend.dif
> 
> Regards,
> florin

Thanks! Did you ever find out what had happened to the test that hung
last night?

Cheers
  Trond
