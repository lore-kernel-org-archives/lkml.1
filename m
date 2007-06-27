Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbXF0Hcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbXF0Hcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXF0Hc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:32:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47629 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXF0Hc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:32:28 -0400
Date: Wed, 27 Jun 2007 00:11:28 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Keith Chew <keith.chew@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb_fill_bulk_urb() broken for USB1.1?
Message-ID: <20070627071128.GA26853@kroah.com>
References: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com> <46815269.8060507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46815269.8060507@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 01:52:41PM -0400, Chuck Ebbert wrote:
> On 06/26/2007 10:20 AM, Keith Chew wrote:
> 
> [cc: linux-usb-devel]
> 
> > We have been using a Zydas based WIFI drivers under kernel 2.6.16.18
> > with great success. Recently, when we upgraded to 2.6.20.1 (also
> > tested on 2.6.21.5), we found that during initialisation, these calls
> > works with USB2.0 but stopped working on USB1.1:
> > 
> > usb_fill_bulk_urb();
> > usb_submit_urb();
> > 
> > The error code returned is -22 (-EINVAL). In 2.6.16.18, it works for
> > both USB2.0 and 1.1.
> > 
> > When we change to use usb_fill_int_urb(), it then works for USB1.1,
> > but takes up to 15 seconds (usually less than 5 seconds) for the
> > driver to initialise. Also, usb_fill_int_urb() does not work for
> > USB2.0 (kernel panic).
> > 
> > Can anyone point us to the right direction on how to get
> > usb_fill_bulk_urb() working on USB1.1? We need this as not all of the
> > deployed machines have USB2.0 enabled.

Do you have a pointer to where this code is so that we can see if the
driver is doing something "odd"?

thanks,

greg k-h
