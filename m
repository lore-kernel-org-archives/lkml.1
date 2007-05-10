Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXEJAKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXEJAKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759770AbXEJAKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:10:19 -0400
Received: from mx2.netapp.com ([216.240.18.37]:16289 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760602AbXEJAKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:10:16 -0400
X-IronPort-AV: i="4.14,512,1170662400"; 
   d="scan'208"; a="58592883:sNHT15048152"
Subject: Re: [bisect] NFS regression breaks X
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Lever <chuck.lever@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070509155228.d1b9d644.akpm@linux-foundation.org>
References: <46423D62.2070200@garzik.org>
	 <1178748206.6760.3.camel@heimdal.trondhjem.org>
	 <20070509155228.d1b9d644.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 09 May 2007 20:10:13 -0400
Message-Id: <1178755813.6760.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 10 May 2007 00:10:28.0005 (UTC) FILETIME=[9D4BB550:01C79297]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 15:52 -0700, Andrew Morton wrote:
> It's a bit rough that Jeff spent a large amount of time hunting down an
> already-known bug.  That's normally my job :(

The bug was reported by Florin Iucha (on lkml!) on Saturday. It has only
just been debugged, and I was in fact in the middle of marshalling the
fixes.

> This five-week-old diff only ever appeared in 2.6.21-mm1, which was
> released four days ago.  It was then whizzed into mainline.  We thus lost
> five weeks public testing which would probably have saved Jeff his pain.
> 
> What went wrong?

Probably my fault. I've had a couple of weeks of heavy travel due to
various circumstances that were beyond my control, and so I had little
time in which to test the stuff and push it out.

Another factor that is affecting us is the slow but gradual collapse of
the OSDL NFSv4 regression testing effort.

Trond
