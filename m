Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXIUIGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXIUIGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbXIUIGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:06:20 -0400
Received: from www.osadl.org ([213.239.205.134]:50328 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751129AbXIUIGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:06:17 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <18163.19912.127570.192406@cargo.ozlabs.ibm.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <1190299841.3481.37.camel@chaos> <1190303393.3639.0.camel@chaos>
	 <200709202239.11070.rjw@sisk.pl> <1190322532.3085.42.camel@chaos>
	 <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
	 <18163.19912.127570.192406@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 10:06:15 +0200
Message-Id: <1190361975.3085.106.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 14:51 +1000, Paul Mackerras wrote:
> Linus Torvalds writes:
> 
> > It would indeed be nice if we could just take CPU's down early (while 
> > everything is working), and run the whole suspend code with just one CPU, 
> > rather than having to worry about the ordering between CPU and device 
> > takedown.
> 
> That is certainly what we want to do on powerpc.

I would have expected that we do it exactly this way and it took me by
surprise, that we do not.

	tglx


