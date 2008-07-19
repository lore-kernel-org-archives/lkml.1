Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYGSQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYGSQO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 12:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYGSQOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 12:14:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:58383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYGSQOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 12:14:20 -0400
Date: Sat, 19 Jul 2008 09:14:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
Message-ID: <20080719091420.14127633@infradead.org>
In-Reply-To: <1216483685.3978.161.camel@localhost.localdomain>
References: <20080718151524.5ef9e29b@infradead.org>
	<20080718151608.46dc17c0@infradead.org>
	<1216430540.3978.137.camel@localhost.localdomain>
	<20080718204406.7426e8fe@infradead.org>
	<1216440697.3978.142.camel@localhost.localdomain>
	<20080718222014.34754e7b@infradead.org>
	<1216481066.3978.159.camel@localhost.localdomain>
	<20080719083532.21c9a43e@infradead.org>
	<1216483685.3978.161.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 09:08:05 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> On Sat, 2008-07-19 at 08:35 -0700, Arjan van de Ven wrote:
> 
> > > Ok .. I'm not trying to rush you .. With that said, the increased
> > > number of threads seems like a natural direction to take.. I would
> > > assume the returns would diminish depending on the number of
> > > threads per the hardware.. For instance , your addition of one
> > > thread might even harm the boot time on some single core embedded
> > > systems ..
> > 
> > well it still improves the cases where msleep() happens... even on
> > single core. (fwiw the test  machine I reported numbers from is
> > single core, albeit with hyperthreading)
> > 
> 
> How did you measure the boot time? I didn't notice any infrastructure
> for that in the patches..
> 

well.. we already have the printk-timestamps and the initcall_debug
also timestamps individual initcalls...

the way I measured it was based on the printk timestamp of the last
thing the kernel did before giving control to init. (which was a printk
I added just for this purpose)
(and the bootchart tool also confirmed the same data, based on system
uptime)

fwiw I have more patches coming to help boottime once these are done,
but these 3 were self contained and ready for posting, the others need
some more cleanup first.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
