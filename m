Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXCaQmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXCaQmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXCaQmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:42:04 -0400
Received: from ns.suse.de ([195.135.220.2]:40062 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbXCaQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:42:01 -0400
Date: Sat, 31 Mar 2007 09:41:52 -0700
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Jens Axboe <jens.axboe@oracle.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
Message-ID: <20070331164152.GA13976@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <460BBD1B.4040308@ru.mvista.com> <200703291531.18253.maximlevitsky@gmail.com> <200703291546.48996.maximlevitsky@gmail.com> <1175356272.28263.27.camel@localhost.localdomain> <Pine.LNX.4.64.0703310908160.6730@woody.linux-foundation.org> <1175358800.28263.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175358800.28263.36.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 06:33:20PM +0200, Thomas Gleixner wrote:
> On Sat, 2007-03-31 at 09:09 -0700, Linus Torvalds wrote:
> > 
> > On Sat, 31 Mar 2007, Thomas Gleixner wrote:
> > > 
> > > While I agree in principle with the patch, I'm a bit uncomfortable. The
> > > sys device suspend / resume ordering is not guaranteed and relies on the
> > > registering order.
> > 
> > Well, this is why we probably should try to get away from the "system 
> > device" issue, exactly because system devices are totally outside the 
> > normal ordering and only have a random linear order.
> > 
> > If the clocksources were actually in the device tree, you'd get all the 
> > normal guarantees about hierarchical ordering..
> 
> Right, but clock - sources/events need to be extremly late suspended and
> early resumed. How can we ensure this ?

Put it at the top of the device tree.

thanks,

greg k-h
