Return-Path: <linux-kernel-owner+w=401wt.eu-S1763961AbYARRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763961AbYARRqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYARRqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:46:00 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:21249 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbYARRp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:45:58 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Stephen Tweedie <sct@redhat.com>
In-Reply-To: <4790E193.20003@goop.org>
References: <1200375906.3505.30.camel@caritas-dev.intel.com>
	 <1200646105.17230.28.camel@cthulhu.hellion.org.uk>
	 <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com>
	 <4790BD90.9060303@zytor.com>
	 <1200671665.9891.45.camel@localhost.localdomain>
	 <20080118162257.GB6819@elte.hu>  <4790E193.20003@goop.org>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 17:45:46 +0000
Message-Id: <1200678346.32050.3.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - enhance bt_ioremap
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 09:27 -0800, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > * Ian Campbell <ijc@hellion.org.uk> wrote:
> >
> >   
> >>> Eric Biederman had a patchset that makes a PAE kernel use PAE page 
> >>> tables from the start.  That is really The Right Thing[TM].
> >>>       
> >> That's much saner than dup'ing up the early ioremap stuff to support 
> >> both PAE and non-PAE at runtime, which is about the only idea I've got 
> >> for fixing this right now...
> >>
> >> I think I'll just back out the early_ioremap patches locally for now 
> >> and wait for Eric's patches which should cause the fix for this issue 
> >> to just fall out in the wash.
> >>     
> >
> > Eric's patchset is nowhere near being submitted - he _had_ a patchset. 
> > So this needs to be fixed by the Xen-guest folks. (if the easiest/best 
> > fix is to pick up Eric's patchset, then plese do it so)
> >   
> 
> This is only relevent to dom0 isn't it?  sct is looking at that at the 
> moment.  

The early_ioremap stuff gets called on domU too, for example
get_bios_ebda(). Or was the intention that these should be gated at a
higher level?

Ian.
-- 
Ian Campbell

Pie are not square.  Pie are round.  Cornbread are square.

