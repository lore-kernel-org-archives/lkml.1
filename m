Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZCEOIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZCEOIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZCEOIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:08:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:43721 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbZCEOIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:08:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,307,1233561600"; 
   d="scan'208";a="117084598"
Date: Thu, 5 Mar 2009 22:07:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Markus <M4rkusXXL@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: drop_caches ...
Message-ID: <20090305140708.GA23369@localhost>
References: <200903041057.34072.M4rkusXXL@web.de> <200903041947.41542.M4rkusXXL@web.de> <20090305004850.GA6045@localhost> <200903051255.35407.M4rkusXXL@web.de> <20090305133603.GA22442@localhost> <20090305140125.GD646@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305140125.GD646@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 04:01:25PM +0200, Lukas Hejtmanek wrote:
> On Thu, Mar 05, 2009 at 09:36:03PM +0800, Wu Fengguang wrote:
> > > filesize and "cached" the amount of the file being in cache (why can 
> > > this be bigger than the file?!).
> > 
> >           size = file size in bytes
> >         cached = cached pages
> > 
> > So it's normal that (size > cached).
> 
> and one more thing. It seems that at least in the version of filecache I have,
> the size and cached are in kB rather than in B.

Ah sorry for the confusion, it is in KB: DIV_ROUND_UP(size, 1024).
It may be better to simply use bytes though.

Thanks,
Fengguang

