Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYDGGdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYDGGdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 02:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYDGGdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 02:33:36 -0400
Received: from www.tglx.de ([62.245.132.106]:41489 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYDGGdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 02:33:35 -0400
Date: Mon, 7 Apr 2008 08:27:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roman Zippel <zippel@linux-m68k.org>
cc: john stultz <johnstul@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Close small window for vsyscall time inconsistencies
In-Reply-To: <200804070255.22516.zippel@linux-m68k.org>
Message-ID: <alpine.LFD.1.10.0804070826390.3224@apollo.tec.linutronix.de>
References: <1207340264.6222.17.camel@localhost.localdomain> <200804070255.22516.zippel@linux-m68k.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, Roman Zippel wrote:
> Hi,
> 
> On Friday 4. April 2008, john stultz wrote:
> 
> > So Thomas and Ingo pointed out to me that they were occasionally seeing
> > small 1ns inconsistencies from clock_gettime() (and more rarely, 1us
> > inconsistencies from gettimeofday() when the 1ns inconsistency occurred
> > on a us boundary)
> 
> What does inconsistency mean?

Time is going backwards by 1us/1nsec.
 
> So instead of shooting in the dark, I'd suggest to collect some
>  numbers first,

That's what we did and John's analysis of the problem is pretty
correct.

Thanks,
	tglx
