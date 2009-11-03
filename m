Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZKCHV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZKCHV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZKCHV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:21:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:6231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZKCHV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:21:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,673,1249282800"; 
   d="scan'208";a="206859800"
Subject: Re: [RFC 2/2] Use unified UUID/GUID definition in gfs2
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091102170249.d1bf0aea.akpm@linux-foundation.org>
References: <1255501807.6047.1193.camel@yhuang-dev.sh.intel.com>
	 <20091101093545.a7a4693a.akpm@linux-foundation.org>
	 <1257123583.30470.1161.camel@yhuang-dev.sh.intel.com>
	 <20091102150221.948d8427.akpm@linux-foundation.org>
	 <1257209088.30470.1171.camel@yhuang-dev.sh.intel.com>
	 <20091102170249.d1bf0aea.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 15:21:59 +0800
Message-Id: <1257232919.22519.40.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 09:02 +0800, Andrew Morton wrote: 
> On Tue, 03 Nov 2009 08:44:48 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > For stuff of no use to user space, I think it can be enclosed into
> > 
> > #ifdef __KERNEL__
> > #endif
> 
> It can, but that's ugly.  Clearly separating the inclusions into uuid-kernel.h
> and uuid-user-h is nicer, no?

But it seems that __KERNEL__ is common used method now. There are about
370 out of 3085 files under linux/include use __KERNEL__. The data are
gotten via:

# cd linux/include
# find . -type f | wc -l
# grep __KERNEL__ -lr * | wc -l

Best Regards,
Huang Ying


