Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754863AbYJBV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYJBV3g (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 2 Oct 2008 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYJBV3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:29:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbYJBV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:29:24 -0400
Subject: Re: Agere Hermes source-code: copyright situation
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Dave <kilroyd@googlemail.com>,
        TJ <linux@tjworld.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Casual J. Programmer" <casualprogrammer@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Alexander Shirshikov <alexander.shirshikov@gmail.com>
In-Reply-To: <20081002203731.GA25314@kroah.com>
References: <200809290949.35749.arvidjaar@mail.ru>
	 <20081001200039.GA29874@kroah.com> <48E400FA.2090305@gmail.com>
	 <200810020637.27321.arvidjaar@mail.ru> <20081002200023.GC20902@kroah.com>
	 <1222979517.12505.33.camel@72-58-93-37.area3.spcsdns.net>
	 <20081002203731.GA25314@kroah.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 17:28:34 -0400
Message-Id: <1222982914.12505.37.camel@72-58-93-37.area3.spcsdns.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 13:37 -0700, Greg KH wrote:
> On Thu, Oct 02, 2008 at 04:31:57PM -0400, Dan Williams wrote:
> > On Thu, 2008-10-02 at 13:00 -0700, Greg KH wrote:
> > > On Thu, Oct 02, 2008 at 06:37:18AM +0400, Andrey Borzenkov wrote:
> > > > TJ you can answer me using arvidjaar (at) newmail dot ru. Hopefully
> > > > one of them works. Re WPA2 - there is no information how to setup
> > > > CCMP/AES (even if firmware supports it); so no WPA2.
> > > > 
> > > > On Thursday 02 October 2008, Dave wrote:
> > > > > Greg KH wrote:
> > > > > > On Wed, Oct 01, 2008 at 05:40:29PM +0100, TJ wrote:
> > > > > >> On Wed, 2008-10-01 at 14:13 +0400, Andrey Borzenkov wrote:
> > > > > >>>On Wednesday 01 October 2008, Greg KH wrote:
> > > > > >>>> On Mon, Sep 29, 2008 at 09:49:34AM +0400, Andrey Borzenkov wrote:
> > > > > >>>>> I have here driver that can be built for two different types of
> > > > > >>>>> hardware from basically the same sources (this is port of old Agere
> > > > > >>>>> drivers for Hermes-I/Hermes-II chipsets).
> > > > > >>>> 
> > > > > >>>> Cool, do you have a link to the code, I'd be glad to add it to
> > > > > >>>> drivers/staging/ if it's not in a fully-mergable state yet to get wider
> > > > > >>>> users for it.
> > > > > >>>
> > > > > >>> You can look at it here: http://arvidjaar.newmail.ru/wlags49.tar.bz
> > > > > >>>
> > > > > >>> I doubt that it is suitable for inclusion at current state if ever.
> > > > > >>> This is taken directly from Agere 2.4 sources; the only parts that were
> > > > > >>> touched are kernel glue and wireless extensions interface.
> > > > > >>>
> > > > > >>> And it is not GPL'ed, of course. I attach E-Mail I received a while
> > > > > >>> back with answere from Agere legal department.
> > > > > >>
> > > > > >> I'm attaching the original email I sent to Agere and their response for
> > > > > >> the record, hoping it helps clarify the legal position.
> > > > > > 
> > > > > > Very nice, thanks for forwarding this on.
> > > > > > 
> > > > > > As the license is BSD, that means we can place it in the kernel tree.
> > > > > > Do you all mind if I add it to the drivers/staging/ directory so you can
> > > > > > work on cleaning it up within the main kernel tree infrastructure?
> > > > >
> > > > 
> > > > I do not mind but it is likely makes no sense for H-I now; and
> > > > I do not own H-II myself so cannot work on it. If we are focusing on
> > > > H-2/2.5, it would make more sense to make similar modifications to
> > > > 7.22 driver set from Agere to avoid overlap with Orinoco.
> > > 
> > > Ok, let me know what you think is the best thing to do, and I'll be glad
> > > to help you out with it.
> > 
> > I tend to think that only for USB hardware do we need a new driver, and
> > that driver can share some things with both hostap and orinoco.  If at
> > all possible, lets integrate missing hardware support into _existing_
> > drivers instead of importing drivers of questionable quality.  I've seen
> > wlags49 before and it's not great.  Right now we don't have any viable
> > Orinoco USB driver, and while linux-wlan-ng was proposed, there's no way
> > we're taking a third 802.11 "stack" or the bits in those drivers that
> > overlap with existing drivers' hardware support.
> 
> I just added the wlan-ng usb driver (and stack) to the drivers/staging/
> tree a few hours ago :)
> 
> So yes, we do need to do this kind of migration, at the moment I am
> trying to track down all out-of-tree drivers that distros and users are
> relying on to get them into staging/ and then we can work on cleaning
> them up and moving them to the proper place in the kernel tree.
> 
> Sound good?
> 
> So, for this driver, should I do the same thing, as I don't think these
> devices are covered by any other driver at the moment, right?

Prism II USB devices are only covered by linux-wlan-ng, yes.

Dan


