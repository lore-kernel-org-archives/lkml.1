Return-Path: <linux-kernel-owner+w=401wt.eu-S2993294AbXDTRY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993294AbXDTRY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993295AbXDTRY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:24:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993294AbXDTRY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:24:28 -0400
Date: Fri, 20 Apr 2007 13:21:47 -0400
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
Message-ID: <20070420172147.GC20118@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
References: <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org> <20070420050344.GG20566@redhat.com> <46284C84.6060301@goop.org> <20070420051908.GH20566@redhat.com> <462850B3.70901@goop.org> <20070420145126.GC25051@redhat.com> <4628DC0A.60707@goop.org> <20070420160308.GB20118@redhat.com> <4628F586.3040606@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4628F586.3040606@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:16:54AM -0700, Jeremy Fitzhardinge wrote:
 > Dave Jones wrote:
 > >  > Andi, I think.  I've got his firstfloor.org patches applied to this kernel.
 > >
 > > Ah, I saw you patched in CFS too, and thought it may be related.
 > >   
 > 
 > Well, I have CONFIG_FB_BACKLIGHT enabled, and it still works.
 > 
 > Maybe there's something in Andi's queue which is making it work?

Shrug, I'm out of ideas.  I'm hoping that it'll magically start working
when people start flushing their git trees for .22
Maybe that'll yield a clue for something that can be backported to .21.x
because right now, I'm completely puzzled.

I was testing on a vanilla 2.6.21-rc7-git3.

	Dave

-- 
http://www.codemonkey.org.uk
