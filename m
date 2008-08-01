Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYHAPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYHAPon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYHAPof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:44:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYHAPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:44:34 -0400
Date: Fri, 1 Aug 2008 17:44:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080801154445.GZ23938@one.firstfloor.org>
References: <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org> <20080731225004.GD22426@elte.hu> <48926FC3.3000706@keyaccess.nl> <20080801095105.GA18055@elte.hu> <48931D69.2010309@keyaccess.nl> <20080801144917.GY23938@one.firstfloor.org> <48932975.80508@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48932975.80508@keyaccess.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 05:19:17PM +0200, Rene Herman wrote:
> On 01-08-08 16:49, Andi Kleen wrote:
> 
> >>For real ISA at the least, the best fix I feel is just not go grabbing 
> >>resources without anything (ie, ISAPnP) or anyone (ie, the user) telling 
> >
> >Really old systems don't have isapnp. Neither have smbus devices.
> >
> >>us that's where the hardware's at.
> >
> >That would mean the users on these systems would need to add tons
> >of obscure command line options.
> 
> No, it means users on those 1% of systems that are using drivers that 
> break the other 99% would have to for those one or two drivers that do.
> 
> And as said, we don't care.

Not sure who "we" is in this context.

Especially dropping easy support for all smbus devices (which are often like
 this) would seem quite wrong to me. And for real ISA devices there tends to 
be a surprisingly large user base left for those.

The config option Ingo proposed is a good idea though.

Or they can just use 64bit which never defines CONFIG_ISA, but of course
still has to support all the similar smbus drivers.
-Andi

