Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbXIUE7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbXIUE7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 00:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbXIUE7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 00:59:40 -0400
Received: from ozlabs.org ([203.10.76.45]:52479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbXIUE7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 00:59:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18163.19912.127570.192406@cargo.ozlabs.ibm.com>
Date: Fri, 21 Sep 2007 14:51:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
 booted, USB-related WARNING
In-Reply-To: <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<1190299841.3481.37.camel@chaos>
	<1190303393.3639.0.camel@chaos>
	<200709202239.11070.rjw@sisk.pl>
	<1190322532.3085.42.camel@chaos>
	<alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> It would indeed be nice if we could just take CPU's down early (while 
> everything is working), and run the whole suspend code with just one CPU, 
> rather than having to worry about the ordering between CPU and device 
> takedown.

That is certainly what we want to do on powerpc.

Paul.
