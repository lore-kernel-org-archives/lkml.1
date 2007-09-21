Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbXIUTZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbXIUTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXIUTZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:25:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44017 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbXIUTZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:25:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Fri, 21 Sep 2007 21:37:57 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709212120.03044.rjw@sisk.pl> <1190402218.2993.2.camel@chaos>
In-Reply-To: <1190402218.2993.2.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212137.58703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Friday, 21 September 2007 21:16, Thomas Gleixner wrote:
> Rafael,
> 
> On Fri, 2007-09-21 at 21:20 +0200, Rafael J. Wysocki wrote:
> > On Friday, 21 September 2007 18:27, Thomas Gleixner wrote:
> > > I simply rmmod'ed the processor module before suspend and the problem is
> > > solved as well. The cpuidle patches make this problem more prominent due
> > > to the possible more direct switch into lower power states, when we wait for
> > > a long time on something. 
> > 
> > So, perhaps we can add a .suspend()/.resume() routines to the processor driver
> > and use them to disable/enable the cpuidle functionality during a
> > suspend/resume?
> 
> http://tglx.de/private/tglx/p.diff
> 
> untested yet, but I'm on the way to do that :)

Heh, I thought of the same thing. :-)

Greetings,
Rafael
