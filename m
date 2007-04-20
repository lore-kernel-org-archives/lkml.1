Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXDTFGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXDTFGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbXDTFGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:06:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXDTFGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:06:43 -0400
Date: Fri, 20 Apr 2007 01:03:44 -0400
From: Dave Jones <davej@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070420050344.GG20566@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4628482B.6040804@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:57:15PM -0700, Jeremy Fitzhardinge wrote:
 > Adrian Bunk wrote:
 > > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
 > >              workaround: booting with "hpet=disable"
 > > References : http://lkml.org/lkml/2007/3/13/3
 > > Submitter  : Dave Jones <davej@redhat.com>
 > >              Jeremy Fitzhardinge <jeremy@goop.org>
 > > Caused-By  : PCI merge
 > >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
 > > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
 > >              Rafael J. Wysocki <rjw@sisk.pl>
 > > Status     : unknown
 > >   
 > 
 > OK. 2.6.21-rc7 suspend/resume works perfectly for me.  It's the first
 > kernel version in a long time.  I have no workarounds or special boot
 > options.  It's using hpet as the clocksource.

Do you have the backlight code enabled ?
I'm guessing not.

	Dave

-- 
http://www.codemonkey.org.uk
