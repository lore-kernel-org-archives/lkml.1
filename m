Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZEZONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZEZONM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEZONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:13:05 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:52040 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZEZONF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <20090526140423.GA14683@sortiz.org>
References: <20090526140423.GA14683@sortiz.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 26 May 2009 16:11:35 +0200
Message-ID: <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com>
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcel Holtmann <holtmann@linux.intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 16:04, Samuel Ortiz <sameo@linux.intel.com> wrote:

> Since the firmware loader is not maintained by anyone, I'm sending this one to
> you, for the next merge window:

It's part of the driver-core directory, and handled by Greg.

> The firmware loader has a statically allocated 30 bytes long string for the
> firmware id (a.k.a. the firmware file name). There is no reason why we couldnt
> allocate dynamically, and avoid having restrictions on the firmware names
> lengths.

Looks good.

> Please note that we have to keep the FIRMWARE_NAME_MAX definition around as
> some drivers rely on it.

I think the 6 files should be converted, and FIRMWARE_NAME_MAX
removed, otherwise people will keep copying that crap around.

  drivers/pcmcia/ds.c
  drivers/usb/atm/ueagle-atm.c
  drivers/net/wireless/libertas/if_usb.c
  drivers/net/wireless/libertas/if_spi.c
  drivers/media/dvb/dvb-usb/dvb-usb.h
  drivers/media/common/tuners/tuner-xc2028.c

Thanks,
Kay
