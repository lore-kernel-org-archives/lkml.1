Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZG1Qfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZG1Qfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZG1Qfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:35:51 -0400
Received: from kroah.org ([198.145.64.141]:50026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZG1Qfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:35:50 -0400
Date: Tue, 28 Jul 2009 09:34:20 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Oliver Neukum <oliver@neukum.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-ID: <20090728163420.GB14899@kroah.com>
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au>
 <20090728112608.09a494e0@lxorguk.ukuu.org.uk>
 <200907281410.41449.oliver@neukum.org>
 <20090728132911.03ff78ea@lxorguk.ukuu.org.uk>
 <20090728223504.6a6ae8e7.sfr@canb.auug.org.au>
 <20090728141740.44d53b68@lxorguk.ukuu.org.uk>
 <20090728163222.GA14899@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728163222.GA14899@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:32:22AM -0700, Greg KH wrote:
> On Tue, Jul 28, 2009 at 02:17:40PM +0100, Alan Cox wrote:
> > On Tue, 28 Jul 2009 22:35:04 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Alan,
> > > 
> > > On Tue, 28 Jul 2009 13:29:11 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > >
> > > > I need to look at the actual diff, but the combination looks completely
> > > > bogus unless I'm misreading the fixup which is possible.
> > > 
> > > Below is the actual patch from the usb.current tree.
> > 
> > Thanks - ok that is probably safe. The change I was worried about (the
> > error paths not adjusting port->count are ok as it gets zeroed within the
> > mutex)
> > 
> > Not sure its safe versus hangup but neither was the old code 8)
> > 
> > Oliver: I'll send you an alternative patch later today/tomorrow that uses
> > the ASYNC flags.
> 
> Should I just drop Oliver's existing patch from my tree for now then?

Ok, in order to get a good merge for today, I've dropped it now.

Oliver, care to work with Alan to get something that is agreeable to
everyone?

thanks,

greg k-h
