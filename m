Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbXC2Llf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbXC2Llf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXC2Llf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:41:35 -0400
Received: from ns1.suse.de ([195.135.220.2]:37316 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbXC2Lle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:41:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add support for deferrable timers (respun-Mar28)
Date: Thu, 29 Mar 2007 13:41:12 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk,
       johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070328170159.7fc8c289.akpm@linux-foundation.org> <20070329005953.GA8764@linux-os.sc.intel.com>
In-Reply-To: <20070329005953.GA8764@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291341.13172.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> ondemand is the biggest offender and the patch below reduces the number of
> interrupts by 50% or more (depending on HZ) on different test systems here.

Cool!
 
> Yes. There are quite a few other timers inside kernel that can be
> migrated. I will use timer_stats and track others and send in the patches
> soon.

Longer term it might make sense to even expose this as a option to user space.
Maybe as a new timer in setitimer()? This might safe power with "wiggling desktop 
applets" too.

-Andi

