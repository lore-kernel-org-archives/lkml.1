Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbYBWLQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbYBWLQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYBWLQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:16:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48740 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750927AbYBWLQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:16:36 -0500
Date: Sat, 23 Feb 2008 12:17:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: i915 hibernation patch (was: Re: [Suspend-devel] 2.6.25-rc2
	System no longer powers off aftersuspend-to-disk. Screen becomes
	green.)
Message-ID: <20080223111700.GB1909@elf.ucw.cz>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802230031.20292.rjw@sisk.pl> <alpine.LFD.1.00.0802221653000.21332@woody.linux-foundation.org> <200802230255.54510.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802230255.54510.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Apart from those issues it looks fine to me.

> 
> OK, please have a look at the modified patch below.

Seems to work here after basic tests. ACK.

(I discovered that -rc2 swsusp will not power down in some cases, but
it was here before the patch, too...)
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
