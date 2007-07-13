Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbXGMLxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbXGMLxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXGMLxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:53:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59756 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbXGMLxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:53:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 14:01:34 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm> <1184347974.4523.30.camel@caritas-dev.intel.com>
In-Reply-To: <1184347974.4523.30.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131401.35274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 19:32, Huang, Ying wrote:
> On Thu, 2007-07-12 at 20:06 -0700, david@lang.hm wrote:
> > >> I agree, a stipped down hibernate kernel can be very small, not allocating
> > >> this memory until it's needed is a step for the final polishing.
> > >
> > > I'm not sure if I agree with that.  In any case, having to use two different
> > > kernels for hibernation would be a big drawback.
> > 
> > I see it as a big advantage to not have to use the main kernel for the 
> > suspend. please keep it as an option at least.
> 
> Yes. It has additional bonus to make it possible to write/read image
> from a program other than main kernel. For example, for a specific
> mobile device product (Such as Intel MID), a customized ultra-small
> program (or kernel) can be composed to write/read image. That way, the
> hibernate/resume time can be reduced to minimal.

You don't need kexec for that.  This is how the userland hibernation (aka
uswsusp) works.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
