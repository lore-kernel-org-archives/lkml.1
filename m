Return-Path: <linux-kernel-owner+w=401wt.eu-S1162060AbXECOsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162060AbXECOsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162061AbXECOsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:48:40 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:49666 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162060AbXECOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:48:39 -0400
Date: Thu, 3 May 2007 10:43:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503144326.GA26864@Krystal>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal> <20070503080638.GA23000@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070503080638.GA23000@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:38:49 up 90 days,  4:45,  4 users,  load average: 2.23, 2.00, 1.62
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Wed, May 02, 2007 at 07:11:04PM -0400, Mathieu Desnoyers wrote:
> > My statement was probably not clear enough. The actual marker code is
> > useful as-is without any further kernel patching required : SystemTAP is
> > an example where they use external modules to load probes that can
> > connect either to markers or through kprobes. LTTng, in its current state,
> > has a mostly modular core that also uses the markers.
> 
> That just mean you have to load an enormous emount of exernal crap
> that replaces the missing kernel functionality.  It's exactly the
> situation we want to avoid.
> 

It makes sense to use -mm to hold the hole usable infrastructure before
submitting it to mainline. I will submit my core LTTng patches to Andrew
in the following weeks.  There is no hurry, in the LTTng perspective, to
merge the markers sooner, although they could be useful to other
(external) projects meanwhile.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
