Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbXITWFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbXITWFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXITWFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:05:31 -0400
Received: from www.osadl.org ([213.239.205.134]:43852 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbXITWFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:05:30 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <1190299841.3481.37.camel@chaos> <1190303393.3639.0.camel@chaos>
	 <200709202239.11070.rjw@sisk.pl> <1190322532.3085.42.camel@chaos>
	 <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 00:05:29 +0200
Message-Id: <1190325929.3085.79.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Thu, 2007-09-20 at 14:55 -0700, Linus Torvalds wrote:
> And I think that's a damn reasonable thing to agree on: timers (and 
> anything else that CPU shutdown/bringup could *possibly* care about) 
> should be considered core enough that they had better be on the 
> suspend_late/resume_early list.
> 
> Thomas, Rafael, can you verify that at least STR is ok in this respect?

-ETOOTIRED led me too a wrong conclusion, but still it is a valuable
hint that this change is making things work again. I need to go down
into the details of the swsusp_suspend() code path to figure out, what's
the root cause. 

Sorry for the noise, but I'm zooming in.

	tglx


