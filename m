Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYIJOhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYIJOhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYIJOhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:37:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:6002 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYIJOhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=H5BWy/k8JiUpOLg2giH/V9bA/1e2lvlruhBUCNlHKbp8vvUyd2YSH1eDcVsP5NNsgN
         9BO/a9lDUwuRZQuTvFySHDKVaPnKIbS1GA/+q4CxCO7H2+97cFSXDb6wU+/021zt2dBs
         EByBvXaOUbb03/5ULPetmkB1Ed6m25+9Gm5mE=
Date: Wed, 10 Sep 2008 10:37:05 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       Jarod Wilson <jwilson@redhat.com>, Janne Grunau <j@jannau.net>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Message-ID: <20080910143705.GB32156@anvil.corenet.prv>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-7-git-send-email-jwilson@redhat.com> <20080910095832.GA22422@sci.fi> <200809100905.58304.jwilson@redhat.com> <20080910140831.GB22422@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080910140831.GB22422@sci.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 05:08:31PM +0300, Ville Syrjälä wrote:
> On Wed, Sep 10, 2008 at 09:05:58AM -0400, Jarod Wilson wrote:
> > On Wednesday 10 September 2008 05:58:32 Ville Syrjälä wrote:
> > > On Tue, Sep 09, 2008 at 12:05:51AM -0400, Jarod Wilson wrote:
> > > > +config LIRC_ATIUSB
> > > > +	tristate "ATI RF USB Receiver support"
> > > > +	default n
> > > > +	depends on LIRC_DEV
> > > > +	help
> > > > +	  Driver for the ATI USB RF remote receiver
> > > > +
> > >
> > > We already have proper input drivers for these devices (ati_remote and
> > > ati_remote2).
> > 
> > True, though I think some users still prefer using them with the lirc drivers 
> > for assorted reasons. Configuring something like mythtv to work with the 
> > ati_remote{,2} driver appears to be a bit more complex (or at least non-
> > standard vs. several other popular remotes) and not as functional vs. 
> > configuring mythtv w/lirc_atiusb.
> > 
> > http://evuraan.blogspot.com/2008/01/how-to-use-ati-remote-wonder-ii-
> > remote.html
> 
> The X11 limitations are unfortunate but they can be worked around with
> keymap support in the kernel driver.

X's evdev support is also maturing and hopefully hotplug support will be
implemented soon.

> ati_remote2 keymap patch is somewhere
> on it's way upstream as we speak. Not sure about ati_remote though.
> 

Yeah, its in my "next" branch, waiting for .28 to open.

> Furthermore if lirc can already handle input from event devices then the
> lirc_atiusb drivers are simply not needed.
> 
> -- 
> Ville Syrjälä
> syrjala@sci.fi
> http://www.sci.fi/~syrjala/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Dmitry
