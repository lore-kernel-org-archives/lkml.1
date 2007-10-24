Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbXJXQid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbXJXQid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759773AbXJXQYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49894 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759722AbXJXQYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:42 -0400
Date: Wed, 24 Oct 2007 17:27:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gilles Gigan <gilles.gigan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add Nano 7240 driver
Message-ID: <20071024172731.202fb478@the-village.bc.nu>
In-Reply-To: <20071024152240.GB6015@infomag.infomag.iguana.be>
References: <20071024121159.03d209ec.gilles.gigan@gmail.com>
	<20071023192948.1fe5dd8d.akpm@linux-foundation.org>
	<20071024152240.GB6015@infomag.infomag.iguana.be>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 17:22:40 +0200
Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Andrew,
> 
> > > +	case WDIOC_SETOPTIONS:{
> > > +			int retval = -EINVAL;
> > > +
> > > +			if (arg & WDIOS_DISABLECARD) {
> > > +				wdt_disable();
> > > +				retval = 0;
> > > +			}
> > > +
> > > +			if (arg & WDIOS_ENABLECARD) {
> > > +				wdt_enable();
> > > +				retval = 0;
> > > +			}
> > > +
> > > +			return retval;
> > 
> > hrm.  So if userspace does ioctl(..., WDIOS_DISABLECARD|WDIOS_ENABLECARD,
> > that happens to be equivalent to WDIOS_ENABLECARD?
> > 
> > Do all watchdog drivers do it exactly the same way, or are we offering
> > inconsistent interfaces between different drivers?
> 
> I fear that all watchdog drivers do it more or less like this.

Not really an issue. "Mummy if I jump off a cliff it hurts"

