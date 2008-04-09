Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYDINhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYDINhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYDINhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:37:36 -0400
Received: from mx2.netapp.com ([216.240.18.37]:19596 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYDINhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:37:35 -0400
X-IronPort-AV: E=Sophos;i="4.25,629,1199692800"; 
   d="scan'208";a="25643759"
Subject: Re: [GIT] Please pull NFS client fixes against linux-2.6.25-rc8
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Christoph Hellwig <hch@infradead.org>, Bryan Wu <cooloney@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080409132721.GA23852@infradead.org>
References: <1207703414.21370.1.camel@heimdal.trondhjem.org>
	 <20080409082408.GA17458@infradead.org>
	 <1207746758.8303.4.camel@heimdal.trondhjem.org>
	 <20080409132721.GA23852@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 09 Apr 2008 09:37:31 -0400
Message-Id: <1207748251.8303.31.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 09 Apr 2008 13:37:31.0861 (UTC) FILETIME=[DC8C0050:01C89A46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-09 at 09:27 -0400, Christoph Hellwig wrote:
> On Wed, Apr 09, 2008 at 09:12:38AM -0400, Trond Myklebust wrote:
> > That is what this does. For the case of no mmu, generic_file_mmap()
> > compiles into a 'return -ENOSYS;'
> 
> doh, I was under the impression we had a real implementation now.
> Of course then it makes much more sense to just not set .mmap at all,
> which gives the same effect in a more obvious way and without any
> confusion to the reader.  (actually that one gives -ENODEV which I
> assume is for some reason more appropinquate)

I'm assuming there is a reason why the nommu folks want to return ENOSYS
rather than ENODEV when mmap() is unsupported by the hardware.

Bryan, any comments to that?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
