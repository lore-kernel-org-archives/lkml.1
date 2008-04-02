Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbYDBHJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbYDBHJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbYDBHI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:08:57 -0400
Received: from www.tglx.de ([62.245.132.106]:38886 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625AbYDBHI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:08:56 -0400
Date: Wed, 2 Apr 2008 09:08:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chr <chunkeey@web.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with
 2.6.25-rc7
In-Reply-To: <200804020029.12019.chunkeey@web.de>
Message-ID: <alpine.LFD.1.10.0804020820130.3219@apollo.tec.linutronix.de>
References: <200803302109.22219.chunkeey@web.de> <200804010001.51288.chunkeey@web.de> <alpine.LFD.1.10.0804011817310.3219@apollo.tec.linutronix.de> <200804020029.12019.chunkeey@web.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Chr wrote:
> On Tuesday 01 April 2008 18:27:34 Thomas Gleixner wrote:
> > On Tue, 1 Apr 2008, Chr wrote:
> > > Ahhm it happend again (well, actually it's the fifth time today, but this
> > > time I _hopefully_ found something)
> > > 
> > > (direct link)
> > > http://bugzilla.kernel.org/attachment.cgi?id=15542
> >
> > # expires at 4839289000000 nsecs [in -168780949682 nsecs]
> >
> > That's strange. Local APIC timer interrupt seems to be stuck.
> >
> > Can you please upload a boot log and the output of
> > /proc/timer_list of 2.6.24.x to the bugzilla ?
> >
> > Does adding "noapictimer" to the command line help ?
> noapictimer seems to help too... (chrony is on)

Ok. Can you please provide the output of /proc/cpuinfo ?

Thanks,

	tglx
