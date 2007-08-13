Return-Path: <linux-kernel-owner+w=401wt.eu-S937235AbXHMVPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937235AbXHMVPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932523AbXHMVPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:15:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbXHMVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:15:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend, aka swsusp):
Date: Mon, 13 Aug 2007 23:25:03 +0200
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com> <200708132250.15466.rjw@sisk.pl> <1187038479.10249.304.camel@localhost>
In-Reply-To: <1187038479.10249.304.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132325.04810.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 13 August 2007 22:54, Joe Perches wrote:
> On Mon, 2007-08-13 at 22:50 +0200, Rafael J. Wysocki wrote:
> > Please add
> > arch/i386/power/
> > arch/x86_64/kernel/suspend_asm.S
> > arch/x86_64/kernel/suspend.c
> > drivers/base/power/
> > There also is a couple of headers.  Do you want to list them too?
> 
> Your choice.  Just let me know.

+ include/linux/suspend.h
+ include/linux/freezer.h
+ include/linux/pm.h
+ include/asm-*/suspend.h

Hm, they are also relevant for suspend to RAM, so perhaps one common
list of files for suspend to RAM and hibernation would be better?

> HIBERNATION (aka Software Suspend, aka swsusp):
> P:	Pavel Machek
> M:	pavel@suse.cz
> P:	Rafael J. Wysocki
> M:	rjw@sisk.pl
> L:	linux-pm@lists.linux-foundation.org
> S:	Supported
> F:	Documentation/power/swsusp*
> F:	arch/i386/power/
> F:	arch/x86_64/kernel/suspend*
> F:	drivers/base/power/
> F:	kernel/power/
> 
> 
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
