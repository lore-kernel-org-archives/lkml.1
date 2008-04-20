Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYDTViv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYDTViv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYDTVip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:38:45 -0400
Received: from the.earth.li ([217.147.81.2]:50371 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbYDTVio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:38:44 -0400
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 17:38:44 EDT
Date: Sun, 20 Apr 2008 22:07:39 +0100
From: Simon Huggins <huggie@earth.li>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080420210738.GK28693@paranoidfreak.co.uk>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080302104031.GB3861@ucw.cz> <20080303204300.69cbe392@mjolnir.drzeus.cx> <20080303203808.GH13869@elf.ucw.cz> <20080303220530.49201544@mjolnir.drzeus.cx> <20080313211749.GN28693@paranoidfreak.co.uk> <20080315160428.6d25b4e0@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315160428.6d25b4e0@mjolnir.drzeus.cx>
X-Attribution: huggie
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

On Sat, Mar 15, 2008 at 04:04:28PM +0100, Pierre Ossman wrote:
> On Thu, 13 Mar 2008 21:17:49 +0000
> Simon Huggins <huggie@earth.li> wrote:
> > I'm happy to test bits.  What do I need to do to switch time sources for
> > instance?
> I'm no expert, but you have the kernel parameter "clocksource" documented in Documentation/kernel-parameters. Also check the directory /sys/devices/system/clocksource for assorted runtime changes.

Sorry it took so long.

I'm defaulting to hpet but if I try changing clocksource to tsc, jiffies
or acpi_pm with any of the patches at runtime or rebooting it seems to
make no difference and sdhci doesn't work as before.

I tried 2.6.25 too and it's the same story.

I guess I'll just keep HZ=1000.

-- 
 ,--huggie-at-earth-dot-li--------stuff-thing-stuff----------DF5CE2B4--.
_|   "An excellent suggestion sir, with only two minor flaws...." -    |_
 |                               Kryten                                |
 `-------------------- http://www.earth.li/~huggie/ -------------------'
