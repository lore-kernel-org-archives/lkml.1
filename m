Return-Path: <linux-kernel-owner+w=401wt.eu-S1422866AbXBANZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422866AbXBANZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422867AbXBANZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:25:56 -0500
Received: from styx.suse.cz ([82.119.242.94]:58519 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422866AbXBANZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:25:55 -0500
Date: Thu, 1 Feb 2007 14:29:04 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 6/9] Add the "Master Timer"
Message-ID: <20070201132901.GN21755@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.944245000@jet.suse.cz> <200702011222.56056.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011222.56056.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:22:55PM +0100, Andi Kleen wrote:
> >  
> > -unsigned int cpu_khz;					/* TSC clocks / usec, not used here */
> > +unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
> > +static s64 mt_per_tick;		/* master timer ticks per jiffie */
> > +static u64 __mt;		/* master timer */
> > +static u32 __mt_last;		/* value last read from read_master_timer() when updating timer caches */
> 
> Why the underscores? 

To make it clear that the variables should not be used directly.
They should only be accessed through the get_master_timer(),
set_master_timer64(), etc. funcitions.

Something wrong with that? I have no problem deleting the
underscores :-)

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

