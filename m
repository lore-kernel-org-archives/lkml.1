Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXDPH5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXDPH5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbXDPH5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:57:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXDPH5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:57:54 -0400
Date: Mon, 16 Apr 2007 03:55:43 -0400
From: Dave Jones <davej@redhat.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070416075543.GB15281@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Richard Purdie <rpurdie@rpsys.net>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com> <20070416011636.GO3691@stusta.de> <20070416062921.GB7528@redhat.com> <1176706447.5129.6.camel@daplas> <20070416072326.GA15281@redhat.com> <1176708722.5129.8.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176708722.5129.8.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:32:02PM +0800, Antonino A. Daplas wrote:
 > On Mon, 2007-04-16 at 03:23 -0400, Dave Jones wrote:
 > > On Mon, Apr 16, 2007 at 02:54:07PM +0800, Antonino A. Daplas wrote:
 > >  
 > >  > CONFIG_ACPI_VIDEO depends on BACKLIGHT_CLASS_DEVICE, which, in turn is
 > >  > enabled by FB_BACKLIGHT. So we can narrow it down further, can you try?
 > >  > 
 > >  > CONFIG_FB_BACKLIGHT=y
 > >  > CONFIG_ACPI_VIDEO=n
 > > 
 > > That also gets me a dead display. Backlight doesn't turn back on.
 > 
 > Anything under /sys/class/backlight?

Entries from ibm_acpi.  I rmmod'd that, leaving the dir empty,
and it still fails.

	Dave

-- 
http://www.codemonkey.org.uk
