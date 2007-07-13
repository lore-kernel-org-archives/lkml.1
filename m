Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbXGMRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbXGMRTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbXGMRTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:19:14 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52136
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751843AbXGMRTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:19:13 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Start to genericize kconfig for use by other projects.
Date: Fri, 13 Jul 2007 13:19:10 -0400
User-Agent: KMail/1.9.6
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <200707111522.14240.rob@landley.net> <200707121444.18599.rob@landley.net> <20070712231645.GY11166@waste.org>
In-Reply-To: <20070712231645.GY11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131319.10919.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 7:16:45 pm Matt Mackall wrote:
> On Thu, Jul 12, 2007 at 02:44:18PM -0400, Rob Landley wrote:
> > On Thursday 12 July 2007 12:28:39 pm Roman Zippel wrote:
> > > Hi,
> > >
> > > On Wed, 11 Jul 2007, Rob Landley wrote:
> > > > Replace name "Linux Kernel" in menuconfig with a macro (defaulting to
> > > > "Linux Kernel" if not -Ddefined by the makefile), and remove a few
> > > > unnecessary occurrences of "kernel" in pop-up text.
> > >
> > > Could you drop the PROJECT_NAME changes for now? The rest looks fine.
> > > I would prefer if the project would be settable via Kconfig.
> >
> > Are projects likely to grab a common kconfig binary externally, rather
> > than build their own?
>
> Yes.
>
> If you really want to share kconfig, it'd be better to break it off
> into a separately packaged project. For the time being, the kernel
> makefiles can look for it in path, then fall back to its own copy
> which we can eventually drop.

That is _so_ not my call.

Right now, the version in linux-kernel is the master.  I'm not saying that 
should be the case, I'm just saying it is.  That's why I'm pushing patches 
that way rather than recommending anyone else use the version I cleaned up in 
toybox (which is currently fairly standalone).

If somebody wants to break it out and maintain it as a separate project, fine 
with me, just tell me where I should look and where to send patches.  But if 
the linux kernel doesn't actually start _using_ said external version, and 
instead maintains its own, the external version will go the way of libsysfs 
when udev went "a shared library means we include it in our source tree and 
build our own copy".

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
