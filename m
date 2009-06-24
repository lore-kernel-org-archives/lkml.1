Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbZFXTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbZFXTsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761733AbZFXTsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:48:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52502 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762063AbZFXTsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:48:41 -0400
Date: Wed, 24 Jun 2009 12:48:39 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Gary Hade <garyhade@us.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624194839.GG7239@us.ibm.com>
References: <1245845787.3093.3.camel@localhost.localdomain> <4A423686.8050905@lwfinger.net> <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain> <1245859068.3216.5.camel@localhost.localdomain> <20090624161306.GC7239@us.ibm.com> <1245861219.3216.15.camel@localhost.localdomain> <20090624094411.08fc66e6@jbarnes-g45> <20090624175513.GE7239@us.ibm.com> <20090624112849.55b38fff@jbarnes-g45> <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 08:45:31PM +0200, Thomas Gleixner wrote:
> On Wed, 24 Jun 2009, Jesse Barnes wrote:
> > > I was thinking 32 but 64 would be better if there aren't any
> > > downsides elsewhere of making the array that big.
> > 
> > Just chatting with Len about this; apparently the PNPACPI layer ran
> > into something similar awhile back, and they had to go to a variable
> > sized list of resources, due to weird machines with huge numbers of
> > resources.  Matthew says he's got an idea about how to fix this up; if
> > that doesn't work out I'll see about making the bus resource array into
> > a list instead.
> 
> Can we just bring the limit check back and increase the number for now
> until folks come up with a better solution ?

Another possible option is leaving in the limit check (still valid
IMO for correct behavior of previous 'pci=use_crs') and reverting
 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9e9f46c44e487af0a82eb61b624553e2f7118f5b
until the better solution for the fixed size array issue is
available.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

