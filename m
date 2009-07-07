Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZGGJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZGGJjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZGGJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:39:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57787 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZGGJjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:39:05 -0400
Date: Tue, 7 Jul 2009 10:39:07 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
	__alloc_pages_nodemask
Message-ID: <20090707093906.GC26532@csn.ul.ie>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.iyE.f0oUKB@chimera> <alpine.DEB.2.00.0907062101330.31794@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907062101330.31794@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 09:23:03PM -0700, David Rientjes wrote:
> On Tue, 7 Jul 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
> > Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
> > Submitter	: Thomas Meyer <thomas@m3y3r.de>
> > Date		: 2009-06-27 16:15 (10 days old)
> > References	: http://lkml.org/lkml/2009/6/27/75
> > 
> 
> This should be suppressed with the patchset proposed by Mel on linux-mm:
> 
> 	http://marc.info/?l=linux-mm&m=124568542405734
> 	http://marc.info/?l=linux-mm&m=124568542605738
> 	http://marc.info/?l=linux-mm&m=124568542905750
> 	http://marc.info/?l=linux-mm&m=124568543305755
> 
> It doesn't appear that these are in linux-next, however.
> 

In the middle of all the discussions, a few candidate patches haven't
made it upstream. I'm waiting for an mmotm against 2.6.31-rc2 before
going back to see what has been missed that needs resending.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
