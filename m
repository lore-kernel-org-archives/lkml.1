Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458Ab0AHRVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab0AHRVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224Ab0AHRVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:21:05 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:46841 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0AHRVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:21:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=B5UUFFdFPUArKvbwGMDQPm6dnnLTDrT3soflPsHYX7jCcnJs6csHGWUXHO57BzUHfW
         xoai1MfXYv+a/ve+zir/carOV7VQwl9PT6IDgYM49ig/I8X7/fgXRI/jDRfeHhED9AUG
         eDjehXnMHEKsFHu/mr7UMjkIIj0nCgeLR5qnE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
Date: Fri, 8 Jan 2010 09:20:51 -0800
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc3; KDE/4.3.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu> <20100108170450.GB8328@elf.ucw.cz> <20100108171329.GA4711@kroah.com>
In-Reply-To: <20100108171329.GA4711@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001080920.51979.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 January 2010 09:13:29 am Greg KH wrote:
> On Fri, Jan 08, 2010 at 06:04:50PM +0100, Pavel Machek wrote:
> > On Fri 2010-01-08 09:50:33, Rick L. Vinyard, Jr. wrote:
> > > Pavel Machek wrote:
> > > > Hi!
> > > >
> > > >> > +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
> > > >>
> > > >> What this attribute is for?
> > > >
> > > > Actually, all the new files this added need to be documented.
> > >
> > > Which is better? A hid-g13.txt file added to Documentation/ or comments
> > > in the driver itself?
> >
> > Documentation. Coordinate with sysfs maintainer (gregkh).
> 
> All sysfs files need to be documented in Documentation/ABI/  Please add
> the documentation there for your new sysfs files.

We need to have an agreement that all of them are needed first though.

-- 
Dmitry
