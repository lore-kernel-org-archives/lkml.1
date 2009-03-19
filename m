Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbZCSSx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbZCSSx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZCSSxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:53:17 -0400
Received: from kroah.org ([198.145.64.141]:51423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753698AbZCSSxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:53:16 -0400
Date: Thu, 19 Mar 2009 11:51:00 -0700
From: Greg KH <greg@kroah.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Next March 19: drivers/comedi build break.
Message-ID: <20090319185100.GA20608@kroah.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <49C2468A.1040504@in.ibm.com> <20090319153327.GB13963@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090319153327.GB13963@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 08:33:27AM -0700, Greg KH wrote:
> On Thu, Mar 19, 2009 at 06:50:10PM +0530, Sachin Sant wrote:
> > Next 19 randconfig build fails with :
> >
> >  CC [M]  drivers/staging/comedi/comedi_fops.o
> > In file included from drivers/staging/comedi/comedidev.h:38,
> >                 from drivers/staging/comedi/comedi_fops.c:45:
> > drivers/staging/comedi/interrupt.h:25: error: conflicting types for 
> > ‘irqreturn_t’
> > include/linux/irqreturn.h:14: error: previous declaration of 
> > ‘irqreturn_t’ was here
> > In file included from drivers/staging/comedi/comedidev.h:38,
> >                 from drivers/staging/comedi/comedi_fops.c:45:
> > drivers/staging/comedi/interrupt.h:28:1: warning: "IRQ_RETVAL" redefined
> > In file included from include/linux/interrupt.h:10,
> >                 from drivers/staging/comedi/interrupt.h:22,
> >                 from drivers/staging/comedi/comedidev.h:38,
> >                 from drivers/staging/comedi/comedi_fops.c:45:
> > include/linux/irqreturn.h:15:1: warning: this is the location of the 
> > previous definition
> > make[3]: *** [drivers/staging/comedi/comedi_fops.o] Error 1
> >
> > Probably because of the irqreturn_t related changes.
> 
> Ah, I wasn't aware of them, I'll go dig and fix this up...

Now fixed.

thanks,

greg k-h
