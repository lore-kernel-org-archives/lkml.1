Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYHAOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYHAOtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYHAOtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:49:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45605 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYHAOtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:49:06 -0400
Date: Fri, 1 Aug 2008 16:49:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Wolfram Sang <w.sang@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080801144917.GY23938@one.firstfloor.org>
References: <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org> <20080731225004.GD22426@elte.hu> <48926FC3.3000706@keyaccess.nl> <20080801095105.GA18055@elte.hu> <48931D69.2010309@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48931D69.2010309@keyaccess.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 04:27:53PM +0200, Rene Herman wrote:
> On 01-08-08 11:51, Ingo Molnar wrote:
> 
> >find attached below a newer version of the original list i published 
> >half a year ago:
> >
> >   http://people.redhat.com/mingo/auto-qa-patches/Kconfig-qa.patch
> >
> >these are just pragmatic local hacks to get things going. (There are 
> >more per machine quirks as well.)
> >
> >i have not used a BROKEN annotation because CONFIG_BROKEN is 
> >impractical: it just kills code altogether, indiscriminately. There's no 
> >way for users to enable CONFIG_BROKEN in the upstream kernel - nothing 
> >selects it and it's not an interactive option either.
> >
> >So by all means if we mark a driver or a kernel feature as 
> >CONFIG_BROKEN, it's killed altogether for all practical purposes.
> >
> >What we'd need is some more gradual approach: for example a way to mark 
> >"drivers that are not expected to boot on a whitebox PC", without 
> >removing them altogether via a CONFIG_BROKEN dependency - often it's 
> >hardware that cannot be probed safely.
> 
> For real ISA at the least, the best fix I feel is just not go grabbing 
> resources without anything (ie, ISAPnP) or anyone (ie, the user) telling 

Really old systems don't have isapnp. Neither have smbus devices.

> us that's where the hardware's at.

That would mean the users on these systems would need to add tons
of obscure command line options.

-Andi
