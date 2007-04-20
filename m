Return-Path: <linux-kernel-owner+w=401wt.eu-S2992998AbXDTQGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992998AbXDTQGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993269AbXDTQGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:06:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992998AbXDTQGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:06:53 -0400
Date: Fri, 20 Apr 2007 12:03:08 -0400
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
Message-ID: <20070420160308.GB20118@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org> <20070420050344.GG20566@redhat.com> <46284C84.6060301@goop.org> <20070420051908.GH20566@redhat.com> <462850B3.70901@goop.org> <20070420145126.GC25051@redhat.com> <4628DC0A.60707@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4628DC0A.60707@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 08:28:10AM -0700, Jeremy Fitzhardinge wrote:
 > Dave Jones wrote:
 > > -BUG: at arch/i386/kernel/sched-clock.c:170 init_sched_clock()
 > > - [<c01091b5>] show_trace_log_lvl+0x1a/0x30
 > > - [<c010980c>] show_trace+0x12/0x14
 > > - [<c01098cb>] dump_stack+0x16/0x18
 > > - [<c0468dbd>] init_sched_clock+0x58/0x9b
 > > - [<c0461502>] init+0x14b/0x241
 > > - [<c0108d97>] kernel_thread_helper+0x7/0x10
 > > - =======================
 > >
 > > heh, one for Ingo :)
 > Andi, I think.  I've got his firstfloor.org patches applied to this kernel.

Ah, I saw you patched in CFS too, and thought it may be related.

 > > So most of the differences seem to be BIOS/firmware rather than hardware. 
 > > The PCI bus layout is identical for eg.
 > 
 > Do you have Intel wireless?  I realized one chance I'd made was to swap
 > the Atheros wireless with Intel, since it just seems to work better
 > overall.  I'd never had any major suspend/resume problems that I could
 > attribute to madwifi though (lots of minor wifi-related ones though).

yeah, the intel wireless.  Same as teh one in your pci.gz attachment..
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
	Subsystem: Intel Corporation Unknown device 1010
	Flags: bus master, fast devsel, latency 0, IRQ 21

	Dave

-- 
http://www.codemonkey.org.uk
