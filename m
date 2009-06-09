Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbZFIT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbZFIT7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZFIT7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:59:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36241 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZFIT7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:59:09 -0400
Date: Tue, 9 Jun 2009 21:59:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans-Joachim Picht <hans@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 05/38] s390: hibernation support for s390
Message-ID: <20090609195903.GB1388@ucw.cz>
References: <20090604161847.513682672@de.ibm.com> <20090604161900.659762303@de.ibm.com> <20090608064451.GD1444@ucw.cz> <20090609153402.58e6b841@blc4eb509856389.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609153402.58e6b841@blc4eb509856389.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-09 15:34:02, Hans-Joachim Picht wrote:
> On Mon, 8 Jun 2009 08:44:51 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> 
> > > Index: linux-2.6/arch/s390/power/swsusp.c
> > > ===================================================================
> > > --- /dev/null
> > > +++ linux-2.6/arch/s390/power/swsusp.c
> > > @@ -0,0 +1,31 @@
> > > +/*
> > > + * Support for suspend and resume on s390
> > > + *
> > > + * Copyright IBM Corp. 2009
> > > + *
> > > + * Author(s): Hans-Joachim Picht <hans@linux.vnet.ibm.com>
> > > + *
> > > + */
> > > +
> > > +#include <linux/suspend.h>
> > > +#include <linux/gfp.h>
> > > +#include <linux/cpu.h>
> > > +#include <linux/smp.h>
> > > +#include <linux/cpumask.h>
> > > +#include <asm/ipl.h>
> > > +#include <asm/processor.h>
> > 
> > Empty functions do not need 1000 includes...
> 
> Thanks for spotting this. I will remove these.
>  
> > > +/*
> > > + * save CPU registers before creating a hibernation image and
> > > before
> > > + * restoring the memory state from it
> > > + */
> > > +void save_processor_state(void)
> > > +{
> > > +}
> > > +
> > > +/*
> > > + * restore the contents of CPU registers
> > > + */
> > > +void restore_processor_state(void)
> > > +{
> > > +}
> > 
> > ...and explaining why the functions can be emmpty would be nice.
> 
> I integrated the code for this in the assembly backend in the
> swsusp_arch_suspend & swsusp_arch_resume functions.

I guessed so. Maybe it is worth a comment?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
