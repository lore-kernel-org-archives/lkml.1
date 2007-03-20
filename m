Return-Path: <linux-kernel-owner+w=401wt.eu-S933978AbXCTE3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbXCTE3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933977AbXCTE3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:29:40 -0400
Received: from ns.suse.de ([195.135.220.2]:50467 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933978AbXCTE3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:29:39 -0400
Date: Mon, 19 Mar 2007 21:27:34 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
Message-ID: <20070320042734.GA9700@kroah.com>
References: <200703161230.03712.maximlevitsky@gmail.com> <1174088686.13341.347.camel@localhost.localdomain> <200703162132.53906.lenb@kernel.org> <1174127539.3538.207.camel@laptopd505.fenrus.org> <p73k5xg6lwe.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73k5xg6lwe.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 02:26:57PM +0100, Andi Kleen wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > well we can do the handshake to take ownership like we do much later in
> > boot, but that requires PCI to be there and fully discovered, which we
> > don't have this early.
> 
> That's not true - we do early pci discovery. Doing USB handsoff
> there would be quite possible.

What, we don't do USB "handoff" early enough in the boot process?  It's
happening at PCI quirk time now, which I think should be early enough
for everyone (and too early for some who rely on USB keyboards and
initramfs shells...)

thanks,

greg k-h
