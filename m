Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbYAMLGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbYAMLGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 06:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYAMLGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 06:06:13 -0500
Received: from [212.12.190.216] ([212.12.190.216]:35749 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751235AbYAMLGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 06:06:12 -0500
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/5] USB Kconfig: Reorganize USB Kconfig Menu
Date: Sun, 13 Jan 2008 14:05:34 +0300
User-Agent: KMail/1.5
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801051546.SAA08937@raad.intranet> <200801121320.46580.a1426z@gawab.com> <20080112195333.GA4924@kroah.com>
In-Reply-To: <20080112195333.GA4924@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801131405.34775.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Jan 12, 2008 at 01:20:46PM +0300, Al Boldi wrote:
> > Greg KH wrote:
> > > On Sat, Jan 05, 2008 at 06:40:38PM +0300, Al Boldi wrote:
> > > > Reorganize USB Kconfig Menu, and move USB_GADGET out into the Device
> > > > Driver Menu. ?This helps the USB Kconfig Menu to be more
> > > > logical/usable.
> > > >
> > > > Patchset against 2.6.23
> > >
> > > So what was the final verdict in this patch set?
> >
> > IMHO, it's a lot better than what we have right now, and it's split up
> > so that you can pick and choose what you think is useful.
> >
> > > Can you rsend this against 2.6.24-rc7 with the requested changes (if
> > > any) in it?
> >
> > The only critical change is in patch 2/5:
> >
> >         menuconfig USB_STORAGE
> >         tristate "USB Mass Storage support"
> > -       depends on USB && SCSI
> > +       depends on USB && BLOCK
> > +       select SCSI
> >
> >
> > I was hoping you could take care of it, or maybe wait until 2.6.25 is
> > out.
>
> Well, if you want such a change to go into 2.6.25, I need the patches
> now :)
>
> So, can you respin these against 2.6.24-rc7, with the above fix, so that
> I can apply them and test them out?

Not so easy, as I don't have rc7 available.  You know, dialup.


Thanks!

--
Al

