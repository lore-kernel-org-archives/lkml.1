Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZCENhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZCENhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCENg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:36:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:44474 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZCENg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:36:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,307,1233561600"; 
   d="scan'208";a="117074946"
Date: Thu, 5 Mar 2009 21:36:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Markus <M4rkusXXL@web.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: drop_caches ...
Message-ID: <20090305133603.GA22442@localhost>
References: <200903041057.34072.M4rkusXXL@web.de> <200903041947.41542.M4rkusXXL@web.de> <20090305004850.GA6045@localhost> <200903051255.35407.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903051255.35407.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On Thu, Mar 05, 2009 at 01:55:35PM +0200, Markus wrote:
> > Markus, you may want to try this patch, it will have better chance to figure out
> > the hidden file pages.
> > 
> > 1) apply the patch and recompile kernel with CONFIG_PROC_FILECACHE=m
> > 2) after booting:
> >         modprobe filecache
> >         cp /proc/filecache filecache-`date +'%F'`
> > 3) send us the copied file, it will list all cached files, including
> >    the normally hidden ones.
> 
> The file consists of 674 lines. If I interpret it right, "size" is the 
> filesize and "cached" the amount of the file being in cache (why can 
> this be bigger than the file?!).

          size = file size in bytes
        cached = cached pages

So it's normal that (size > cached).

Thanks,
Fengguang
