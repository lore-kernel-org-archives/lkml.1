Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXFMXCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXFMXCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbXFMXCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:02:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48637 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbXFMXCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:02:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Seyfried <seife@suse.de>
Subject: Re: [PATCH, 2nd try] make disable_console_suspend runtime configurable
Date: Thu, 14 Jun 2007 01:09:04 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Frank Seidel <fseidel@suse.de>, akpm@linux-foundation.org,
       nigel@nigel.suspend2.net
References: <20070613200303.GB11437@suse.de> <20070613220800.GD2611@elf.ucw.cz> <20070613222308.GA17266@suse.de>
In-Reply-To: <20070613222308.GA17266@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140109.04866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 June 2007 00:23, Stefan Seyfried wrote:
> On Thu, Jun 14, 2007 at 12:08:00AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > I hate having to recompile the kernel, just to be able to debug suspend.
> > > Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> > > /sys/power/disable_console_suspend.
> > 
> > > Signed-off-by: Stefan Seyfried <seife@suse.de>
> > > Signed-off-by: Frank Seidel <fseidel@suse.de>
> > 
> > I wonder if there's a better name?
> 
> Suggest one.
> 
> > Or maybe this should not be /sys configurable, but just have value for
> > each console "this console can work while suspended"?
> > 
> > (serial can, vesafb can, netconsole can't)?
> 
> Go ahead, submit a patch. It won't be that trivial. And i wonder
> if it is actually worth the hassle. This is a debugging facility.
> 
> > Exporting "crash-me" option to user does not seem that cool to me.
> 
> We have "echo c > /proc/sysrq-trigger" also.
> This is a debugging option, and forcing users to recompile the kernel just
> to debug suspend problems (not resume problems, the "it does not even go to
> sleep" stuff is where this matters most) is IMO a bad idea.
> 
> We can also make this a boot parameter, i don't care, but i want to disable
> console suspend without recompiling the kernel.

It's a bit similar to the pm_trace thing.

As long as there is a sane default (ie. the consoles are disabled), I don't see
a big problem with that.

Moreover, distributions will probably want to have a switch so that they can
tell the user "please do 'echo 1 > ...' and retest" and if they start to add
such things by themselves that wouldn't be nice.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
