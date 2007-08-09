Return-Path: <linux-kernel-owner+w=401wt.eu-S935235AbXHIGar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935235AbXHIGar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbXHIGai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:30:38 -0400
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:26710 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758828AbXHIGah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:30:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qs9BtFqQsdDvzf87ABw0F6aLnZhqsTpUskj4Xvz+ICyRkW/gyqQxktQbVGjJxoD5txL8r/PyPdA9pj7lwtY7CjuE9OIBN/dthqFN1DjvkC/T58gfI2pvockZ95d2RnjDmVSusAJUnNsRvvRSRAoo2gJytD0fXs4TvY35IO/hY7g=  ;
X-YMail-OSG: 3soIMdsVM1mBk501cWLZekZhBQFxP.Moh6jB8LnLL5SmK59r2kMfjQr4acs5mC052FdtbnMlYA--
From: David Brownell <david-b@pacbell.net>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Add missing newlines to some uses of dev_<level> messages
Date: Wed, 8 Aug 2007 23:30:09 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Tony Luck <tony.luck@intel.com>,
       Jiri Slaby <jirislaby@gmail.com>, Roland Dreier <rolandd@cisco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       James Smart <james.smart@emulex.com>, Hansjoerg Lipp <hjlipp@web.de>,
       Jean Delvare <khali@linux-fr.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
References: <1186535381.11897.29.camel@localhost>
In-Reply-To: <1186535381.11897.29.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708082330.10604.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Splitting by subsystem *would* have been better ...

On Tuesday 07 August 2007, Joe Perches wrote:
>  drivers/i2c/chips/menelaus.c           |    2 +-

ok ...

>  drivers/net/usb/mcs7830.c              |   16 +++++++-------

... ok ...

>  drivers/rtc/rtc-sysfs.c                |    5 +--

... ok ...

>  drivers/spi/atmel_spi.c                |    2 +-
>  drivers/spi/spi_bfin5xx.c              |    2 +-
>  drivers/spi/spi_imx.c                  |    4 +-

... ok ... 

>  drivers/usb/class/cdc-acm.c            |   34 ++++++++++++++++----------------
>  drivers/usb/core/endpoint.c            |    2 +-
>  drivers/usb/core/message.c             |    4 +-
>  drivers/usb/host/ohci-s3c2410.c        |    2 +-
>  drivers/usb/misc/adutux.c              |    4 +-
>  drivers/usb/misc/iowarrior.c           |    8 +++---
>  drivers/usb/misc/phidgetmotorcontrol.c |    2 +-
>  drivers/usb/serial/ftdi_sio.c          |    4 +-
>  drivers/usb/serial/io_edgeport.c       |    2 +-
>  drivers/usb/serial/ipw.c               |   18 ++++++++--------
>  drivers/usb/serial/mos7720.c           |    4 +-
>  drivers/usb/serial/oti6858.c           |    2 +-
>  drivers/usb/serial/sierra.c            |   10 ++++----

... ok ...

ACK.
