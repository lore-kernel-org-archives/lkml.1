Return-Path: <linux-kernel-owner+w=401wt.eu-S1161157AbXDNHoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157AbXDNHoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 03:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161162AbXDNHoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 03:44:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161157AbXDNHn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 03:43:59 -0400
Date: Sat, 14 Apr 2007 03:40:30 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Marcus Better <marcus@better.se>, adaplas@gmail.com,
       James Simmons <jsimmons@infradead.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [3/3] 2.6.21-rc6: known regressions
Message-ID: <20070414074030.GA29635@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Tobias Diedrich <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
	linux-pm@lists.osdl.org, Jeremy Fitzhardinge <jeremy@goop.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
	linux-pci@atrey.karlin.mff.cuni.cz,
	Tobias Doerffel <tobias.doerffel@gmail.com>,
	Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
	Marcus Better <marcus@better.se>, adaplas@gmail.com,
	James Simmons <jsimmons@infradead.org>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070414003808.GU5907@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414003808.GU5907@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 02:38:08AM +0200, Adrian Bunk wrote:

 > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
 >              workaround: booting with "hpet=disable"
 > References : http://lkml.org/lkml/2007/3/13/3
 > Submitter  : Dave Jones <davej@redhat.com>
 >              Jeremy Fitzhardinge <jeremy@goop.org>
 > Caused-By  : PCI merge
 >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
 > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
 >              Rafael J. Wysocki <rjw@sisk.pl>
 > Status     : problem is being debugged

I'm at a loss on this one. git bisect was non-conclusive.
I even tried beating up on Eric's console-over-usb to try
and get more useful info, but I failed miserably.

	Dave

-- 
http://www.codemonkey.org.uk
