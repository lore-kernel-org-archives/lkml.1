Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYIJOIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYIJOIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYIJOIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:08:34 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56147 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbYIJOId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:08:33 -0400
Date: Wed, 10 Sep 2008 17:08:31 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Jarod Wilson <jwilson@redhat.com>
Cc: Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Message-ID: <20080910140831.GB22422@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Jarod Wilson <jwilson@redhat.com>, Janne Grunau <j@jannau.net>,
	linux-kernel@vger.kernel.org,
	Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-7-git-send-email-jwilson@redhat.com> <20080910095832.GA22422@sci.fi> <200809100905.58304.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200809100905.58304.jwilson@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 09:05:58AM -0400, Jarod Wilson wrote:
> On Wednesday 10 September 2008 05:58:32 Ville Syrjälä wrote:
> > On Tue, Sep 09, 2008 at 12:05:51AM -0400, Jarod Wilson wrote:
> > > +config LIRC_ATIUSB
> > > +	tristate "ATI RF USB Receiver support"
> > > +	default n
> > > +	depends on LIRC_DEV
> > > +	help
> > > +	  Driver for the ATI USB RF remote receiver
> > > +
> >
> > We already have proper input drivers for these devices (ati_remote and
> > ati_remote2).
> 
> True, though I think some users still prefer using them with the lirc drivers 
> for assorted reasons. Configuring something like mythtv to work with the 
> ati_remote{,2} driver appears to be a bit more complex (or at least non-
> standard vs. several other popular remotes) and not as functional vs. 
> configuring mythtv w/lirc_atiusb.
> 
> http://evuraan.blogspot.com/2008/01/how-to-use-ati-remote-wonder-ii-
> remote.html

The X11 limitations are unfortunate but they can be worked around with
keymap support in the kernel driver. ati_remote2 keymap patch is somewhere
on it's way upstream as we speak. Not sure about ati_remote though.

Furthermore if lirc can already handle input from event devices then the
lirc_atiusb drivers are simply not needed.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
