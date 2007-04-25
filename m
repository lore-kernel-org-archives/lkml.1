Return-Path: <linux-kernel-owner+w=401wt.eu-S2992732AbXDYNER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992732AbXDYNER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992737AbXDYNER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:04:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992731AbXDYNEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:04:16 -0400
Date: Wed, 25 Apr 2007 09:01:02 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425130102.GA10141@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.linux-foundation.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
	linux-pci@atrey.karlin.mff.cuni.cz,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214909.GD3468@stusta.de> <20070425040605.6d6b4a82.akpm@linux-foundation.org> <20070425113102.GU3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425113102.GU3468@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 01:31:02PM +0200, Adrian Bunk wrote:
 > On Wed, Apr 25, 2007 at 04:06:05AM -0700, Andrew Morton wrote:
 > > On Mon, 23 Apr 2007 23:49:09 +0200 Adrian Bunk <bunk@stusta.de> wrote:
 > >...
 > > > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
 > > >              workaround: CONFIG_FB_BACKLIGHT=n
 > > > References : http://lkml.org/lkml/2007/3/13/3
 > > > Submitter  : Dave Jones <davej@redhat.com>
 > > > Caused-By  : PCI merge
 > > >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
 > > > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
 > > >              Rafael J. Wysocki <rjw@sisk.pl>
 > > >              Antonino A. Daplas <adaplas@gmail.com>
 > > > Status     : unknown
 > > 
 > > Is this related to the problems Jeremy has been looking at?
 > >...
 > 
 > Dave and Jeremy hran into similar looking but most likely different 
 > problems.
 > 
 > For Jeremy -rc7 is working fine, but for Dave it doesn't.

I think this was due to Jeremy not having CONFIG_FB_BACKLIGHT=y in his config.

	Dave

-- 
http://www.codemonkey.org.uk
