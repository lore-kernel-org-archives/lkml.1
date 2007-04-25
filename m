Return-Path: <linux-kernel-owner+w=401wt.eu-S2992830AbXDYQfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992830AbXDYQfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992841AbXDYQfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:35:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992830AbXDYQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:35:08 -0400
Date: Wed, 25 Apr 2007 12:31:45 -0400
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
Message-ID: <20070425163145.GA6630@redhat.com>
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
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214909.GD3468@stusta.de> <20070425040605.6d6b4a82.akpm@linux-foundation.org> <20070425113102.GU3468@stusta.de> <20070425130102.GA10141@redhat.com> <1177509014.29878.12.camel@daplas> <1177509136.29878.14.camel@daplas> <20070425143305.GB27215@redhat.com> <1177514682.4856.24.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177514682.4856.24.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:24:42PM +0800, Antonino A. Daplas wrote:
 > On Wed, 2007-04-25 at 10:33 -0400, Dave Jones wrote:
 > > On Wed, Apr 25, 2007 at 09:52:16PM +0800, Antonino A. Daplas wrote:
 > >  > > And have you tried the following settings:
 > >  > > FB_BACKLIGHT=y
 > >  > > ACPI_IBM=n
 > >  > > ACPI_VIDEO=n
 > > 
 > 
 > BTW, there was one report where resume from RAM resulted in a screen
 > full of garbage.  It seems that the option acpi_sleep= (or s2ram -a3)
 > did not work for him anymore.  But it worked with s2ram and other
 > options. So if you have s2ram, try:
 > 
 > s2ram -f -s -a3
 > s2ram -f -m -a3
 > s2ram -f -p -m
 > s2ram -f -p -s

I just did a pull of linus' tree, and it now works for me fine.
Adrian, I think we can remove this from the list.

I can't explain what fixed it (or even what caused it in the first place),
but it seems to be behaving itself.

	Dave

-- 
http://www.codemonkey.org.uk
