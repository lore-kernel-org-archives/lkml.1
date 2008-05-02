Return-Path: <linux-kernel-owner+w=401wt.eu-S935345AbYEBPkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935345AbYEBPkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763658AbYEBPkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:40:11 -0400
Received: from www.tglx.de ([62.245.132.106]:38029 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250AbYEBPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:40:10 -0400
Date: Fri, 2 May 2008 17:34:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: Fix permissions for available_clocksource
In-Reply-To: <20080502152730.GA5220@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.10.0805021731550.6003@apollo.tec.linutronix.de>
References: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.10.0805021635030.6003@apollo.tec.linutronix.de> <20080502152730.GA5220@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Heiko Carstens wrote:
> On Fri, May 02, 2008 at 04:36:37PM +0200, Thomas Gleixner wrote:
> > On Fri, 2 May 2008, Heiko Carstens wrote:
> > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > 
> > > File permissions for
> > > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > are 600 which allows write access. But this is in fact a read only
> > > file. So change permissions to 400.
> > 
> > Indeed. The question is whether we should make this 444. There is no
> > harm, when users can read the info. Same applies for the
> > current_clocksource entry, making it 644 should be fine.
> 
> Sure, I can send an on-top patch for this.

Yes, please.
 
> Btw. did you recently try writing "jiffies" to current_clocksource?
> That seems to be a trick to stop the clock...

Hmm, that's after the kernel switched to highres and/or nohz, right ?
This came up earlier, but it got dropped from my to todo list. :(
Will have a look.

Thanks,

	tglx
