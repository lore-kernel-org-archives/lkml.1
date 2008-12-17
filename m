Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758206AbYLQMDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYLQMDW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYLQMDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:03:09 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:52471 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYLQMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:03:08 -0500
Date: Wed, 17 Dec 2008 12:03:05 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        Willy Tarreau <w@1wt.eu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
        venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 68/83] x86: HPET: convert WARN_ON to WARN_ON_ONCE
Message-ID: <20081217120305.GK13247@console-pimps.org>
References: <20081211190201.612240183@mini.kroah.org> <20081211191620.GP5894@kroah.com> <20081217112625.GJ13247@console-pimps.org> <s5h4p13dojm.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4p13dojm.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 12:33:17PM +0100, Takashi Iwai wrote:
> At Wed, 17 Dec 2008 11:26:25 +0000,
> Matt Fleming wrote:
> > 
> > On Thu, Dec 11, 2008 at 11:16:20AM -0800, Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Matt Fleming <mjf@gentoo.org>
> > > 
> > > commit 1de5b0854623d30d01d72cd4ea323eb5f39d1f16 upstream.
> > > 
> > > It is possible to flood the console with call traces if the WARN_ON
> > > condition is true because of the frequency with which this function is
> > > called.
> > > 
> > 
> > If this commit is going into stable it would be worth adding these
> > two commits (which are actually the bugfixes).
> > 
> > 5ceb1a04187553e08c6ab60d30cee7c454ee139a
> > x86: HPET: enter hpet_interrupt_handler with interrupts disabled
> > 
> > 89d77a1eb60be916d85d9394bedbfa2037af89c5
> > x86: HPET: read from HPET_Tn_CMP() not HPET_T0_CMP
> 
> I think the latter isn't applicable as 2.6.27 supports only T0.
> 

Ah, thanks. I wasn't aware of that.
