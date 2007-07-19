Return-Path: <linux-kernel-owner+w=401wt.eu-S940444AbXGSRTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940444AbXGSRTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938348AbXGSRTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:19:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51810 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938117AbXGSRTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:19:17 -0400
Date: Thu, 19 Jul 2007 12:19:13 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christian Ehrhardt <lk@c--e.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719171913.GA1275@sergelap.austin.ibm.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <1184864070.2694.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184864070.2694.3.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arjan van de Ven (arjan@infradead.org):
> 
> > Right, the ability to boot with security.capability=disabpled (or
> > whatever) and then load a custom module without having to use a whole
> > new kernel is something I'm sure end-users want.
> > 
> > Especially since compiling a kernel which works with, say, a default
> > fedora install, with lvm etc, is not imo for a novice (where novice
> > != security novice).
> 
> the next step after this patch is to have an option to get rid of all
> the function pointer chasing (which is expensive) for the case where you
> know you only want one security module (which you then can turn on or
> off)... that advantage is a performance gain for a lot of people.... but
> if the person configuring the kernel selects this, it does mean there's
> no way to load modules. I don't know what Fedora will do, but they might
> select such an option. That's CHOICE...

War is peace
Freedom is slavery
Ignorance is strength
	-1984

:)

Actually, given that when lsm was being introduced, lsm seemed to
improve performance overall, have you taken any measurements to show
that this is actually the case?  Of course it makes sense that it would,
but witjout measurements we do not know.

> they chose a performance

> improvement over enabling external kernel modules that they don't ship
> anyway...
> 
> but is it really worth blocking such clear improvements in performance?

I'm blocking nothing.

In fact I concede that this patch might force any out of tree module
authors to come to the table, which is a good thing.

-serge
