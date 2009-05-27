Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbZE0GUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbZE0GUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbZE0GUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:20:05 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53598 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452AbZE0GUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:20:04 -0400
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, "Zhu, Yi" <yi.zhu@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       Greg Kroah-Hartmann <greg@kroah.com>
In-Reply-To: <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com>
References: <20090526140423.GA14683@sortiz.org>
	 <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 08:19:46 +0200
Message-Id: <1243405186.20399.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> > Since the firmware loader is not maintained by anyone, I'm sending this one to
> > you, for the next merge window:
> 
> It's part of the driver-core directory, and handled by Greg.
> 
> > The firmware loader has a statically allocated 30 bytes long string for the
> > firmware id (a.k.a. the firmware file name). There is no reason why we couldnt
> > allocate dynamically, and avoid having restrictions on the firmware names
> > lengths.
> 
> Looks good.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

> > Please note that we have to keep the FIRMWARE_NAME_MAX definition around as
> > some drivers rely on it.
> 
> I think the 6 files should be converted, and FIRMWARE_NAME_MAX
> removed, otherwise people will keep copying that crap around.
> 
>   drivers/pcmcia/ds.c
>   drivers/usb/atm/ueagle-atm.c
>   drivers/net/wireless/libertas/if_usb.c
>   drivers/net/wireless/libertas/if_spi.c
>   drivers/media/dvb/dvb-usb/dvb-usb.h
>   drivers/media/common/tuners/tuner-xc2028.c

I do agree with Kay here that we should just go ahead and fix these.

Regards

Marcel


