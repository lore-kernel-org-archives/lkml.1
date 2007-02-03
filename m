Return-Path: <linux-kernel-owner+w=401wt.eu-S1946483AbXBCQKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946483AbXBCQKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 11:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946480AbXBCQKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 11:10:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:33094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946481AbXBCQKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 11:10:46 -0500
Date: Sat, 3 Feb 2007 08:09:32 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de, linux-serial@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers/isdn/gigaset: new M101 driver
Message-ID: <20070203160932.GA32523@kroah.com>
References: <200702012112.l11LCOO4016557@lx1.pxnet.com> <20070201171345.bd98ce30.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201171345.bd98ce30.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 05:13:45PM -0800, Andrew Morton wrote:
> > +/* dummy to shut up framework warning */
> > +static void gigaset_device_release(struct device *dev)
> > +{
> > +	//FIXME anything to do? cf. platform_device_release()
> > +}
> 
> Ask Greg ;)

Oh come on people.  Don't provide an empty function because the kernel
is complaining that you don't provide a release function.  Yes it will
shut the kernel up but did you ever think _why_ the kernel was
complaining?  Did you think it did it just for fun?

Think people, think...

You need to free your memory here, don't just provide an empty function,
that shows the driver is broken.

thanks,

greg k-h
