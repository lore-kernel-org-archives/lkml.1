Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbXE0QUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbXE0QUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbXE0QUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:20:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbXE0QUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:20:30 -0400
Subject: Re: USB: set default y for CONFIG_USB_DEVICE_CLASS
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg KH <greg@kroah.com>, bert hubert <bert.hubert@netherlabs.nl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490705270910q2fde0e19i1e60393cef7b86d4@mail.gmail.com>
References: <20070527150458.GA3803@vrfy.org>
	 <9a8748490705270910q2fde0e19i1e60393cef7b86d4@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 27 May 2007 18:19:34 +0200
Message-Id: <1180282774.3131.54.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19XYU92lmz7i0haVYXukpJ+whaxl3woJ00zieC
 v4s3twztfnwGS7n7PEyMLKvAG4H/WpaascTyWAJKU+JJWX9d9r
 +SISQPCL3r7v8rvecGsQVXwlzYEeVyM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 18:10 +0200, Jesper Juhl wrote:
> On 27/05/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: USB: set default y for CONFIG_USB_DEVICE_CLASS
> >
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > ---
> >
> > diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
> > index f493fb1..346fc03 100644
> > --- a/drivers/usb/core/Kconfig
> > +++ b/drivers/usb/core/Kconfig
> > @@ -40,21 +40,25 @@ config USB_DEVICEFS
> >  config USB_DEVICE_CLASS
> >         bool "USB device class-devices (DEPRECATED)"
> >         depends on USB
> > -       default n
> > +       default y
> 
> It puzzles me why a deprecated option should be default 'Y'...

Because usb_device class devices are kind of broken regarding the event
timing, and should not be used anymore. They are replaced by
device-nodes created by the real usb-device, but some systems still
depend on the class devices:
   http://lkml.org/lkml/2007/5/27/56

We better default to y for a while until the users have switched over.

Kay

