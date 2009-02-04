Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZBDH5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZBDH5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 02:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZBDH5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 02:57:36 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:42555 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZBDH5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 02:57:35 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [stable]  A patch in 2.6.27.9 caused device names to change
Date: Wed, 4 Feb 2009 08:28:44 +0100
User-Agent: KMail/1.9.10
Cc: Dan Williams <dcbw@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
References: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com> <1233672611.11344.6.camel@localhost.localdomain> <20090204000342.GB22380@kroah.com>
In-Reply-To: <20090204000342.GB22380@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040828.45615.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 04 February 2009 01:03:42 schrieb Greg KH:
> On Tue, Feb 03, 2009 at 09:50:11AM -0500, Dan Williams wrote:
 
> > For a long time we've been operating under the assumption that mobile
> > broadband devices should be driven by option and sierra, since those
> > drivers had the necessary buffering optimizations to support
> > higher-speed mobile broadband devices.
> 
> Who is "we" here?  Not me :)

We currently have three drivers that can handle high speed serial
connections in USB, option, sierra and cdc-acm.
 
> > That was true at least up until 2.6.24.
> 
> It all depends on the type of device.  If it says it is a cdc-acm modem,
> by all means, let that driver handle it, don't try to bind it to a
> different driver (that way lies races and madness...)
> 
> > Furthermore, up until this point, I have not seen mobile broadband
> > adapters (that aren't cellphones connected via USB) that *are* CDC-ACM
> > compliant.  Everything previously has advertised proprietary interfaces,
> > some of which are serial ports and some of which are not.
> 
> Probably because we never see those devices being reported, because they
> "just work" with no interaction from us.

As far as I can tell, devices implementing the class specification are
new and still quite rare. This is probably related to the relative newness
of the WHC specification.
  
> > Plus, are we expected to keep device names stable these days?  cdc-acm
> > is the catch-all driver, but if that driver is more "generic" and a
> > better driver is found, can we not update IDs just because the device
> > name may change?

There is no such thing as a better driver for a device that correctly
implements the class specification than the class driver. You haven't
seen complaints about cdc-acm's performance in a long time, have you?

	Regards
		Oliver
