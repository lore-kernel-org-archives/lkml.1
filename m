Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZEZUYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZEZUYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbZEZUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:24:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964AbZEZUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:24:05 -0400
Date: Tue, 26 May 2009 13:23:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: sameo@linux.intel.com, holtmann@linux.intel.com, yi.zhu@intel.com,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com, greg@kroah.com
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
Message-Id: <20090526132351.9805f1e8.akpm@linux-foundation.org>
In-Reply-To: <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com>
References: <20090526140423.GA14683@sortiz.org>
	<ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 16:11:35 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Tue, May 26, 2009 at 16:04, Samuel Ortiz <sameo@linux.intel.com> wrote:
> 
> > Since the firmware loader is not maintained by anyone, I'm sending this one to
> > you, for the next merge window:
> 
> It's part of the driver-core directory, and handled by Greg.

To which it doesn't apply.  It needed more fixes than I felt like making.

> > The firmware loader has a statically allocated 30 bytes long string for the
> > firmware id (a.k.a. the firmware file name). There is no reason why we couldnt
> > allocate dynamically, and avoid having restrictions on the firmware names
> > lengths.
> 
> Looks good.
> 
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

Yep.

