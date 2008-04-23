Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYDWMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYDWMOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYDWMOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:14:30 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:34585 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYDWMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:14:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj8FAIfFDkhMROPA/2dsb2JhbACBUqwA
Date: Wed, 23 Apr 2008 08:14:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Kyle McMartin <kyle@mcmartin.ca>, Paul Mackerras <paulus@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [RFC patch 6/9] POWERPC remove -traditional
Message-ID: <20080423121426.GA25947@Krystal>
References: <20080422172404.502954084@polymtl.ca> <20080422172842.427209743@polymtl.ca> <18446.48624.515912.541936@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <18446.48624.515912.541936@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:11:38 up 54 days,  8:22,  4 users,  load average: 0.50, 0.38,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras (paulus@samba.org) wrote:
> Mathieu Desnoyers writes:
> > Subject: [RFC patch 6/9] Re: [PATCH] Stringify support commas
> >  > This is a no-no for those archs that still use -traditional.
> >  > > I dunno if this is a problem for you at the moment and the
> >  > > right fix is anyway to nuke -traditional.
> >  > > 
> >  > >     Sam
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Sam Ravnborg <sam@ravnborg.org>
> > CC: paulus@samba.org
> > CC: linuxppc-dev@ozlabs.org
> > ---
> >  arch/powerpc/boot/Makefile |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Looks OK.  I'll put it in my tree.
> 
> Paul.

OK, although it won't be needed with v2 of the stringify with commas.
There seems to be some important details which differ between
-traditional and stdc gcc operation which makes it non-trivial to remove
the -traditional, at least on sparc. Maybe Kyle could tell us a bit more
about the nature of these limitations ?

I would wait a bit before merging until we at least identify what those
limitations are.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
