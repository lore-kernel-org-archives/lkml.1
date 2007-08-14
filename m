Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbXHNR1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbXHNR1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbXHNR1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:27:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbXHNR1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:27:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend, aka swsusp):
Date: Tue, 14 Aug 2007 19:37:05 +0200
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com> <200708132338.25925.rjw@sisk.pl> <20070814070528.GA2903@elf.ucw.cz>
In-Reply-To: <20070814070528.GA2903@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708141937.06676.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 14 August 2007 09:05, Pavel Machek wrote:
> Hi!
> 
> > > > + include/linux/suspend.h
> > > > + include/linux/freezer.h
> > > > + include/linux/pm.h
> > > > + include/asm-*/suspend.h
> > > > 
> > > > Hm, they are also relevant for suspend to RAM, so perhaps one common
> > > > list of files for suspend to RAM and hibernation would be better?
> > > 
> > > Maybe just collapse the 2 maintainers blocks into one?
> 
> No, please don't.

So, I think the F: entries should be the following:

(1) hibernation
F:      Documentation/power/
F:      arch/i386/power/
F:      arch/x86_64/kernel/suspend_asm.S
F:      arch/x86_64/kernel/suspend.c
F:      drivers/base/power/
F:      kernel/power/
F:      include/linux/suspend.h
F:      include/linux/freezer.h
F:      include/linux/pm.h
F:      include/asm-*/suspend.h

(2) suspend
F:      Documentation/power/
F:      arch/i386/kernel/acpi/
F:      arch/x86_64/kernel/acpi/
F:      arch/x86_64/kernel/suspend.c
F:      drivers/base/power/
F:      kernel/power/
F:      include/linux/suspend.h
F:      include/linux/freezer.h
F:      include/linux/pm.h
F:      include/asm-*/suspend.h

> > > HIBERNATION (aka Software Suspend, aka swsusp) and SUSPEND TO RAM:
> > > P:	Pavel Machek
> > > M:	pavel@suse.cz
> > > P:	Rafael J. Wysocki
> > > M:	rjw@sisk.pl
> > > L:	linux-pm@lists.linux-foundation.org
> > > S:	Supported
> > 
> > Then I think it should be "Maintained".
> 
> No, supported is still right :-).

OK

Greetings,
Rafael
