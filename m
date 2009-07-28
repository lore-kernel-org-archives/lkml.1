Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZG1NQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZG1NQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZG1NQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:16:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49329 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbZG1NQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:16:40 -0400
Date: Tue, 28 Jul 2009 14:17:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Oliver Neukum <oliver@neukum.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-ID: <20090728141740.44d53b68@lxorguk.ukuu.org.uk>
In-Reply-To: <20090728223504.6a6ae8e7.sfr@canb.auug.org.au>
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au>
	<20090728112608.09a494e0@lxorguk.ukuu.org.uk>
	<200907281410.41449.oliver@neukum.org>
	<20090728132911.03ff78ea@lxorguk.ukuu.org.uk>
	<20090728223504.6a6ae8e7.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 22:35:04 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alan,
> 
> On Tue, 28 Jul 2009 13:29:11 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > I need to look at the actual diff, but the combination looks completely
> > bogus unless I'm misreading the fixup which is possible.
> 
> Below is the actual patch from the usb.current tree.

Thanks - ok that is probably safe. The change I was worried about (the
error paths not adjusting port->count are ok as it gets zeroed within the
mutex)

Not sure its safe versus hangup but neither was the old code 8)

Oliver: I'll send you an alternative patch later today/tomorrow that uses
the ASYNC flags.

Alan
