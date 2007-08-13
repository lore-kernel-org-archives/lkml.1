Return-Path: <linux-kernel-owner+w=401wt.eu-S937754AbXHMV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937754AbXHMV3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbXHMV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:28:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37862 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbXHMV2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:28:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>, pavel@suse.cz
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend, aka swsusp):
Date: Mon, 13 Aug 2007 23:38:24 +0200
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com> <200708132325.04810.rjw@sisk.pl> <1187040080.10249.323.camel@localhost>
In-Reply-To: <1187040080.10249.323.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132338.25925.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 13 August 2007 23:21, Joe Perches wrote:
> On Mon, 2007-08-13 at 23:25 +0200, Rafael J. Wysocki wrote:
> > + include/linux/suspend.h
> > + include/linux/freezer.h
> > + include/linux/pm.h
> > + include/asm-*/suspend.h
> > 
> > Hm, they are also relevant for suspend to RAM, so perhaps one common
> > list of files for suspend to RAM and hibernation would be better?
> 
> Maybe just collapse the 2 maintainers blocks into one?
> 
> HIBERNATION (aka Software Suspend, aka swsusp) and SUSPEND TO RAM:
> P:	Pavel Machek
> M:	pavel@suse.cz
> P:	Rafael J. Wysocki
> M:	rjw@sisk.pl
> L:	linux-pm@lists.linux-foundation.org
> S:	Supported

Then I think it should be "Maintained".

> F:	Documentation/power/swsusp*

F: Documentation/power/

> F:	arch/i386/kernel/acpi/
> F:	arch/i386/power/
> F:	arch/x86_64/kernel/acpi/
> F:	arch/x86_64/kernel/suspend_asm.S
> F:	arch/x86_64/kernel/suspend.c
> F:	drivers/base/power/
> F:	kernel/power/
> F:	include/linux/suspend.h
> F:	include/linux/freezer.h
> F:	include/linux/pm.h
> F:	include/asm-*/suspend.h

Pavel, what do you think?


-- 
"Premature optimization is the root of all evil." - Donald Knuth
