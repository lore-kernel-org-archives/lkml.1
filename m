Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbXIUNic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbXIUNic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbXIUNi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:38:26 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:49143 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbXIUNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:38:25 -0400
Date: Fri, 21 Sep 2007 09:38:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, dsmith@redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070921133820.GD13129@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal> <20070921133006.GF8964@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070921133006.GF8964@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:37:55 up 53 days, 13:56,  4 users,  load average: 0.07, 0.40, 0.63
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Fri, Sep 21, 2007 at 08:58:19AM -0400, Mathieu Desnoyers wrote:
> > [...]
> > > > Current systemtap marker support code relies on the __markers_strings
> > > > section.
> > > Let users know that in comment above section definition in ld script.
> > [...]
> >         /* Markers: strings (used by SystemTAP) */                      \
> > [...]
> 
> I did not mean to imply that this was a necessary state of affairs.
> 
> The marker metadata must be stored in at least one place in the kernel
> image - this just happens to be a convenient one that David Smith's
> recent systemtap code used.  Without it, we'd probably have to do a
> more complicated search, following the pointers within the __markers
> structs.  That could work, but it hasn't been built/tested.
> 
> So, this proposed change (removal of this section) would break
> systemtap, and we have to jump through more hoops to make it work
> again.  Is the change worth it?
> 

I guess so. Getting the markers as clean as we can is very important for
kernel inclusion.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
