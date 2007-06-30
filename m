Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXF3RWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXF3RWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 13:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXF3RWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 13:22:01 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:58424 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXF3RWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 13:22:00 -0400
Date: Sat, 30 Jun 2007 20:21:54 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-ID: <20070630172154.GA7301@localdomain>
References: <20070630023451.GA21593@localdomain> <4685C549.3020602@intel.com> <20070630025425.59cbc299.akpm@linux-foundation.org> <20070630104752.GA26138@localdomain> <20070630093205.c6ab33af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630093205.c6ab33af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 09:32:05AM -0700, Andrew Morton wrote:
>[..]
> 
> > Given a set of historical modifiers of a file, 
> > would you take the most common commiter(s), or the most common 
> > _recent_ commiter(s), or what? It's a bit fuzzy.
> 
> All the above?  Multiply frequency by recency, pick the top five?
> 
> Doesn't matter much: the cost of picking too many is high.
> 
> I shudder at the thought of manually maintaining anything like this.


Why? It shouldn't take much more effort than the effort currently
being taken to maintain the MAINTAINERS file as it is. This field can
even be considered optional - i.e. let the maintainers themselves who
usually send patches to MAINTAINERS just to update their mailing
address add this field _only if they want to_.

Heck, this way it would even help us to see which maintainers are
more attentive :)
 
> > Moreover, it is slow in comparison and assumes the availability of 
> > local .git db, which wouldn't be the case for some porition of patch 
> > submitters.
> 
> a) precalculate the tables once per week
> 
> b) the whole thing wouldn't succeed if it requires software at
>    patch-submitter's site.  It'd need to run at vger.
> 

And:

c) The script will need to query vger for each file in the patch
via some protocol..

Do you think it's worth the effort?

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
