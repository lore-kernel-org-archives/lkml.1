Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYH1WVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYH1WVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYH1WVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:21:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbYH1WVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:21:05 -0400
Date: Thu, 28 Aug 2008 15:18:28 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Takashi Iwai <tiwai@suse.de>,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
Message-ID: <20080828221828.GB2855@kroah.com>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828200120.GA16462@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 11:01:20PM +0300, Adrian Bunk wrote:
> On Thu, Aug 28, 2008 at 09:05:53PM +0200, Tejun Heo wrote:
> > Hello again,
> > 
> > So, after all the fuss, here's the state-of-the-art standard-compliant
> > cloud-computing web-3.0-beta web page for OSS emulation using CUSE.
> > 
> >   http://userweb.kernel.org/~tj/ossp/
> > 
> > It works pretty well here.  :-)
> 
> Sorry for being destructive, but 6 years after ALSA went into the
> kernel we are slightly approaching the point where all applications 
> support ALSA.
> 
> The application you list on your webpage is UML host sound support,
> and I'm wondering why you don't fix that instead of working on a
> better OSS emulation?

Independant of that, I can see a number of uses for the CUSE code.  One
would be emulating /dev/pilot for old palm pilot software that things it
wants to talk to a serial port, yet really a libusb userspace program
can handle all of the data to the USB device instead.

So don't think that just because this userspace-OSS implementation is
"not what should be done" that CUSE shouldn't be viable.

thanks,

greg k-h
