Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbYFLNOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbYFLNOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbYFLNNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:13:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4193 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757363AbYFLNNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:13:45 -0400
Date: Thu, 12 Jun 2008 15:12:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 4/4] Remove obsolete piece of PM documentation
Message-ID: <20080612131253.GD5455@ucw.cz>
References: <200806121025.24668.rjw@sisk.pl> <200806121031.39186.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806121031.39186.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-12 10:31:38, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove an obsolete piece of PM documentation.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  Documentation/power/pm.txt |  257 ---------------------------------------------
>  1 file changed, 257 deletions(-)
> 
> Index: linux-2.6/Documentation/power/pm.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/pm.txt
> +++ /dev/null
> @@ -1,257 +0,0 @@
> -               Linux Power Management Support
> -
> -This document briefly describes how to use power management with your
> -Linux system and how to add power management support to Linux drivers.
> -
> -APM or ACPI?
> -------------
> -If you have a relatively recent x86 mobile, desktop, or server system,
> -odds are it supports either Advanced Power Management (APM) or
> -Advanced Configuration and Power Interface (ACPI).  ACPI is the newer
> -of the two technologies and puts power management in the hands of the
> -operating system, allowing for more intelligent power management than
> -is possible with BIOS controlled APM.
> -
> -The best way to determine which, if either, your system supports is to
> -build a kernel with both ACPI and APM enabled (as of 2.3.x ACPI is
> -enabled by default).  If a working ACPI implementation is found, the
> -ACPI driver will override and disable APM, otherwise the APM driver
> -will be used.
> -
> -No, sorry, you cannot have both ACPI and APM enabled and running at
> -once.  Some people with broken ACPI or broken APM implementations
> -would like to use both to get a full set of working features, but you
> -simply cannot mix and match the two.  Only one power management
> -interface can be in control of the machine at once.  Think about it..

I'd keep this; it is still true, and we still support both.

Maybe it should be moved into Doc*/power/apm.txt or something.

ACK on rest.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
