Return-Path: <linux-kernel-owner+w=401wt.eu-S1161326AbXDYOg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161326AbXDYOg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161218AbXDYOg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:36:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030924AbXDYOg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:36:58 -0400
Date: Wed, 25 Apr 2007 10:33:05 -0400
From: Dave Jones <davej@redhat.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425143305.GB27215@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.linux-foundation.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
	linux-pci@atrey.karlin.mff.cuni.cz,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Richard Purdie <rpurdie@rpsys.net>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214909.GD3468@stusta.de> <20070425040605.6d6b4a82.akpm@linux-foundation.org> <20070425113102.GU3468@stusta.de> <20070425130102.GA10141@redhat.com> <1177509014.29878.12.camel@daplas> <1177509136.29878.14.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177509136.29878.14.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 09:52:16PM +0800, Antonino A. Daplas wrote:
 > > This is really weird, as CONFIG_FB_BACKLIGHT just selects
 > > BACKLIGHT_CLASS and LCD_CLASS, and adds an entry (bl_curve)
 > > under /sys/class/backlight/*/.

Yeah, it's puzzling to me too.

 > > ACPI_IBM which is set (presumably) in
 > > Dave's kconfig, also selects the BACKLIGHT_CLASS. And the only possible
 > > framebuffer drivers in the thinkpad are vesafb and intelfb, none of
 > > which has a backlight driver.
 > > 
 > > I'm still at a loss how this happens.  Dave, can you post your config?

http://people.redhat.com/davej/config-x60

 > > And have you tried the following settings:
 > > FB_BACKLIGHT=y
 > > ACPI_IBM=n
 > > ACPI_VIDEO=n

I think I've tried that yes.

	Dave

-- 
http://www.codemonkey.org.uk
