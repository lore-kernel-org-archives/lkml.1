Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbXGNPVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbXGNPVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 11:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbXGNPVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 11:21:17 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:53346 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757833AbXGNPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 11:21:10 -0400
Date: Sat, 14 Jul 2007 11:21:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] Text Edit Lock
Message-ID: <20070714152108.GA4737@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714105010.GC7358@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714105010.GC7358@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:20:41 up 7 days,  5:25,  2 users,  load average: 0.01, 0.19, 0.16
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Fri, Jul 13, 2007 at 09:21:33PM -0400, Mathieu Desnoyers wrote:
> > Hi Andrew,
> > 
> > After refactoring of architecture independant code (mutex to protect text
> > edition) vs architecture dependant code (marking/unmarking pages RW) and
> > thorough testing, here is the new version of the text edit lock.
> 
> Do you have a tarball of your quilt series for markers and all the patches
> leading to them?  Trying to hand apply half a dozend patch series is not
> too nice :)
> 

Sure,

Here is the tarball:

http://ltt.polymtl.ca/markers/markers-patches-for-2.6.22-rc6-mm1-07-14-2007.tar.gz

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
