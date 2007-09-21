Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbXIUTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbXIUTRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbXIUTRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:17:03 -0400
Received: from www.osadl.org ([213.239.205.134]:52465 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759432AbXIUTRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:17:02 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <200709212120.03044.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709211620.53794.rjw@sisk.pl> <1190392033.2935.11.camel@chaos>
	 <200709212120.03044.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 21:16:58 +0200
Message-Id: <1190402218.2993.2.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Fri, 2007-09-21 at 21:20 +0200, Rafael J. Wysocki wrote:
> On Friday, 21 September 2007 18:27, Thomas Gleixner wrote:
> > I simply rmmod'ed the processor module before suspend and the problem is
> > solved as well. The cpuidle patches make this problem more prominent due
> > to the possible more direct switch into lower power states, when we wait for
> > a long time on something. 
> 
> So, perhaps we can add a .suspend()/.resume() routines to the processor driver
> and use them to disable/enable the cpuidle functionality during a
> suspend/resume?

http://tglx.de/private/tglx/p.diff

untested yet, but I'm on the way to do that :)

	tglx


