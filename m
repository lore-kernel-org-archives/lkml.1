Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZFZQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZFZQdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZFZQdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:33:09 -0400
Received: from www.tglx.de ([62.245.132.106]:58633 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbZFZQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:33:09 -0400
Date: Fri, 26 Jun 2009 18:32:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
In-Reply-To: <20090626142937.GA19477@elte.hu>
Message-ID: <alpine.LFD.2.00.0906261827490.2767@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com> <20090626071955.GG14078@elte.hu> <20090626101310.4110a290@lxorguk.ukuu.org.uk> <20090626093859.GA12571@elte.hu> <20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
 <20090626110429.GB12446@elte.hu> <20090626125653.5e30bae4@lxorguk.ukuu.org.uk> <20090626122254.GA9959@elte.hu> <20090626133318.5b8de81b@lxorguk.ukuu.org.uk> <20090626142937.GA19477@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Ingo Molnar wrote:
> [ Although it is beyond me why ABP was done - why wasnt HPET good
>   enough? HPET can do per CPU clockevents too and it's just as 
>   off-chip (and hence fundamentally slow) as ABP. ]

Welcome to the wonderful world of embedded systems. Just have a peek
into arch/[arm/powerpc/mips] to see what's coming up to us with full
force. I would not be surprised when we see an x86 system sharing the
device driver for i2c or whatever with an ARM SoC in the foreseable
future.

Thanks,

	tglx


