Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbXFMWXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbXFMWXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXFMWXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:23:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbXFMWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:23:21 -0400
Date: Thu, 14 Jun 2007 00:23:08 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Frank Seidel <fseidel@suse.de>, akpm@linux-foundation.org,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH, 2nd try] make disable_console_suspend runtime configurable
Message-ID: <20070613222308.GA17266@suse.de>
References: <20070613200303.GB11437@suse.de> <20070613220800.GD2611@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070613220800.GD2611@elf.ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha5, Kernel 2.6.22-rc4-git3-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 12:08:00AM +0200, Pavel Machek wrote:
> Hi!
> 
> > I hate having to recompile the kernel, just to be able to debug suspend.
> > Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> > /sys/power/disable_console_suspend.
> 
> > Signed-off-by: Stefan Seyfried <seife@suse.de>
> > Signed-off-by: Frank Seidel <fseidel@suse.de>
> 
> I wonder if there's a better name?

Suggest one.

> Or maybe this should not be /sys configurable, but just have value for
> each console "this console can work while suspended"?
> 
> (serial can, vesafb can, netconsole can't)?

Go ahead, submit a patch. It won't be that trivial. And i wonder
if it is actually worth the hassle. This is a debugging facility.

> Exporting "crash-me" option to user does not seem that cool to me.

We have "echo c > /proc/sysrq-trigger" also.
This is a debugging option, and forcing users to recompile the kernel just
to debug suspend problems (not resume problems, the "it does not even go to
sleep" stuff is where this matters most) is IMO a bad idea.

We can also make this a boot parameter, i don't care, but i want to disable
console suspend without recompiling the kernel.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
