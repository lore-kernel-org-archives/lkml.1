Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbZFINe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbZFINe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbZFINeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:34:06 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:59417 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636AbZFINeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:34:04 -0400
Date: Tue, 9 Jun 2009 15:34:02 +0200
From: Hans-Joachim Picht <hans@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 05/38] s390: hibernation support for s390
Message-ID: <20090609153402.58e6b841@blc4eb509856389.ibm.com>
In-Reply-To: <20090608064451.GD1444@ucw.cz>
References: <20090604161847.513682672@de.ibm.com>
	<20090604161900.659762303@de.ibm.com>
	<20090608064451.GD1444@ucw.cz>
Organization: IBM Deutschland Research & Development GmbH
X-Mailer: Claws Mail 3.7.0cvs74 (GTK+ 2.16.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 08:44:51 +0200
Pavel Machek <pavel@ucw.cz> wrote:


> > Index: linux-2.6/arch/s390/power/swsusp.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/arch/s390/power/swsusp.c
> > @@ -0,0 +1,31 @@
> > +/*
> > + * Support for suspend and resume on s390
> > + *
> > + * Copyright IBM Corp. 2009
> > + *
> > + * Author(s): Hans-Joachim Picht <hans@linux.vnet.ibm.com>
> > + *
> > + */
> > +
> > +#include <linux/suspend.h>
> > +#include <linux/gfp.h>
> > +#include <linux/cpu.h>
> > +#include <linux/smp.h>
> > +#include <linux/cpumask.h>
> > +#include <asm/ipl.h>
> > +#include <asm/processor.h>
> 
> Empty functions do not need 1000 includes...

Thanks for spotting this. I will remove these.
 
> > +/*
> > + * save CPU registers before creating a hibernation image and
> > before
> > + * restoring the memory state from it
> > + */
> > +void save_processor_state(void)
> > +{
> > +}
> > +
> > +/*
> > + * restore the contents of CPU registers
> > + */
> > +void restore_processor_state(void)
> > +{
> > +}
> 
> ...and explaining why the functions can be emmpty would be nice.

I integrated the code for this in the assembly backend in the
swsusp_arch_suspend & swsusp_arch_resume functions.

With best regards,

    --Hans
