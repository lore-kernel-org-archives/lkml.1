Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbXFRGnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbXFRGnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXFRGnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:43:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbXFRGnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:43:16 -0400
Date: Mon, 18 Jun 2007 07:27:47 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org
Subject: Re: [Suspend-devel] [PATCH, 3rd try] make disable_console_suspend runtime configurable
Message-ID: <20070618052747.GA15173@suse.de>
References: <20070613200303.GB11437@suse.de> <200706141414.22152.rjw@sisk.pl> <200706141559.54242.fseidel@suse.de> <200706150020.29189.rjw@sisk.pl> <20070617213530.GE1803@elf.ucw.cz> <20070617214940.GA1951@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070617214940.GA1951@elf.ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha5, Kernel 2.6.22-rc4-git3-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 11:49:40PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > I hate having to recompile the kernel, just to be able to debug suspend.
> > > > Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> > > > /sys/power/disable_console_suspend.
> > > > 
> > > > 
> > > > Signed-off-by: Stefan Seyfried <seife@suse.de>
> > > > Signed-off-by: Frank Seidel <fseidel@suse.de>
> > > > ---
> > > > Third try, renamed sysfs interface to console_suspend 
> > > > reporting and expecting either "enabled" or "disabled"
> > > 
> > > Thanks a lot for redoing it.
> > > 
> > > I have no objections.  Pavel?
> > 
> > I still think that patch is bad. I should have screamed when
> > CONFIG_DISABLE_CONSOLE_SUSPEND went into kernel. That beast should
> > _not_ be configurable, it should just do the right thing.
> > 
> > But I realized that too late. And this only makes it works, making
> > that mistake part of user-kernel interface.
> > 
> > Sorry for not screaming when CONFIG_DISABLE_CONSOLE_SUSPEND went in,
> > but please lets solve this correctly....
> 
> Ouch and sorry for not screaming at "try 1" time. But it still does
> not make the patch right, and I believe that even patch authors agree
> that "no-config-needed" is superior solution.

No, i don't agree at all.

In this case, "no config needed" == "not possible to debug suspend problems".

IMO this is the same as issue as with "sysrq-C". You can crash the machine by
other means, but it sometimes is just handy to have a mechanism to do it.

I do not understand what's the problem with this option. If you want to avoid
that people use it for something else than debugging, i can add a patch that
crashes the machine ten seconds after resume if this option is set.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
