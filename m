Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbXCTJQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbXCTJQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXCTJQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:16:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXCTJQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:16:13 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070320042734.GA9700@kroah.com>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <200703162132.53906.lenb@kernel.org>
	 <1174127539.3538.207.camel@laptopd505.fenrus.org>
	 <p73k5xg6lwe.fsf@bingen.suse.de>  <20070320042734.GA9700@kroah.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 20 Mar 2007 10:14:10 +0100
Message-Id: <1174382050.1158.58.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 21:27 -0700, Greg KH wrote:
> On Sat, Mar 17, 2007 at 02:26:57PM +0100, Andi Kleen wrote:
> > Arjan van de Ven <arjan@infradead.org> writes:
> > > 
> > > well we can do the handshake to take ownership like we do much later in
> > > boot, but that requires PCI to be there and fully discovered, which we
> > > don't have this early.
> > 
> > That's not true - we do early pci discovery. Doing USB handsoff
> > there would be quite possible.
> 
> What, we don't do USB "handoff" early enough in the boot process?  It's
> happening at PCI quirk time now, which I think should be early enough
> for everyone (and too early for some who rely on USB keyboards and
> initramfs shells...)

it's not early enough for this bug, where the SMM code is ruining the
cpu calibrations :)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

