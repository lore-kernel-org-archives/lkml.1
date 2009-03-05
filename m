Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZCENtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZCENtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZCENte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:49:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:20991 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbZCENtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:49:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,307,1233561600"; 
   d="scan'208";a="117078752"
Date: Thu, 5 Mar 2009 21:48:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Markus <M4rkusXXL@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: drop_caches ...
Message-ID: <20090305134842.GB22442@localhost>
References: <200903041057.34072.M4rkusXXL@web.de> <200903041947.41542.M4rkusXXL@web.de> <20090305004850.GA6045@localhost> <200903051255.35407.M4rkusXXL@web.de> <20090305133603.GA22442@localhost> <20090305134528.GC646@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305134528.GC646@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 03:45:28PM +0200, Lukas Hejtmanek wrote:
> On Thu, Mar 05, 2009 at 09:36:03PM +0800, Wu Fengguang wrote:
> >           size = file size in bytes
> >         cached = cached pages
> > 
> > So it's normal that (size > cached).
> 
> I guess, the question was how it can happen that (cached > size).

Ah, because cached size is rounded up to page boundaries,
so a 1K sized file will have 4K cached size.

Thanks,
Fengguang

