Return-Path: <linux-kernel-owner+w=401wt.eu-S1767586AbXDFLOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767586AbXDFLOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 07:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766729AbXDFLOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 07:14:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1236 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767586AbXDFLOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 07:14:01 -0400
Date: Thu, 5 Apr 2007 21:41:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brad Boyer <flar@allandria.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070405214143.GC5513@ucw.cz>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <20070404022544.59b022a6@the-village.bc.nu> <17939.10130.687893.167511@cargo.ozlabs.ibm.com> <1175663999.2932.8.camel@shinybook.infradead.org> <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175666635.2932.17.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Why? What's so special about the name 'ttyS'?
> > 
> > It's the name that users of Linux expect built-in serial ports to have.
> 
> Not really. The norm under Linux is for non-8250 ports to use
> properly-registered device numbers and names. There's not many which are
> still broken in this respect -- it's basically pmac_zilog and some Sun
> UARTs, isn't it?
> 
> And even if it _were_ true, it wouldn't be a particularly good reason
> for changing the way we handle serial ports under Linux.
> 
> > > > The built-in ports can generally be enumerated early on boot in a
> > > > stable order, and they should be assigned the low ttySn numbers,
> > > > regardless of what chip is used to implement them. 
> > > 
> > > I don't see why that 'should' be the case. Certainly it _isn't_ the case
> > > on most supported platforms -- we have separate device numbers, and
> > > names, for most types of ports. There's only one or two drivers which
> > > abuse ttySn for anything other than 8250 ports.
> >
> > It 'should' be the case because that is what is easiest for users and
> > makes most sense from a user's point of view.
> 
> I really don't buy that argument. People cope perfectly well
> with /dev/ttySA0 on StrongARM, with /dev/ttySC0 on SH, etc. If it isn't

Actually I thought that it was a typo when I seen ttySA0 on
openmoko... 

(Which is mostly offtopic here, because the fix for zilog is obviously
needed).

Did not linus say something like 'all devices of one type should use
similar name), in some sata debate?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
