Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZIHFAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZIHFAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 01:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZIHE77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 00:59:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:33701 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZIHE77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 00:59:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,350,1249282800"; 
   d="scan'208";a="548576868"
Subject: Re: [Bisected] Output to external monitor is broken (Re: Linux
	2.6.31-rc9)
From: ykzhao <yakui.zhao@intel.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Ma, Ling" <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090907191219.GA5015@Pilar.aei.mpg.de>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain>
	 <20090906142206.GA4449@Pilar.aei.mpg.de>
	 <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain>
	 <20090907191219.GA5015@Pilar.aei.mpg.de>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Tue, 08 Sep 2009 12:59:48 +0800
Message-Id: <1252385988.3609.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 03:12 +0800, Carlos R. Mafra wrote:
> On Mon  7.Sep'09 at 11:37:39 -0700, Linus Torvalds wrote:
> >   Carlos - can you also do the full dmesg _with_ the corruption? I realize 
> >   that your screen is unreadable, but if you can just log in blindly, and
> >   do a "dmesg > saved-dmesg-file" and then do a clean reboot? No need for 
> >   a serial console or anything fancy - I assume the machine is still 
> >   working, just with bad output.
> > 
> >   It might also be a good idea to boot with "drm.debug=15" to enable much 
> >   more debugging output.
> > 			- Linus ]
> 
> I am no longer at the institute with the monitor to test, but I've already
> uploaded similar debug info to the bugzilla upon ykzhao's request this
> morning (but I think you were not Cc:-ed on that request, though).
Will you please connect the external monitor after the system is already
booted and then enter the X-mode to see whether the external monitor can
work well?
Do you have opportunity to try another external monitor and see whether
this issue still happens?

It will be great if you can attach the output of dmesg with the boot
option of "drm.debug=15" on the failing/working kernel when you can use
the monitor.

Thanks.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14139
> 
> PS: The external monitor is unreadable, but the laptop's screen is still good.

