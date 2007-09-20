Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXITWXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXITWXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXITWXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:23:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbXITWXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:23:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Fri, 21 Sep 2007 00:30:19 +0200
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
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org> <1190325929.3085.79.camel@chaos>
In-Reply-To: <1190325929.3085.79.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709210030.20662.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 00:05, Thomas Gleixner wrote:
> Linus,
> 
> On Thu, 2007-09-20 at 14:55 -0700, Linus Torvalds wrote:
> > And I think that's a damn reasonable thing to agree on: timers (and 
> > anything else that CPU shutdown/bringup could *possibly* care about) 
> > should be considered core enough that they had better be on the 
> > suspend_late/resume_early list.
> > 
> > Thomas, Rafael, can you verify that at least STR is ok in this respect?
> 
> -ETOOTIRED led me too a wrong conclusion, but still it is a valuable
> hint that this change is making things work again.

Yes, it is.

> I need to go down into the details of the swsusp_suspend() code path to
> figure out, what's the root cause. 

If you need any help from me with that, please let me know.

Greetings,
Rafael
