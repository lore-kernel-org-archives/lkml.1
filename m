Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZE0IPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZE0IPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZE0IPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:15:25 -0400
Received: from mga12.intel.com ([143.182.124.36]:3867 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbZE0IPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:15:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,258,1241420400"; 
   d="scan'208";a="147355352"
Date: Wed, 27 May 2009 10:17:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, holtmann@linux.intel.com,
       yi.zhu@intel.com, linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       greg@kroah.com
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
Message-ID: <20090527081732.GB3777@sortiz.org>
References: <20090526140423.GA14683@sortiz.org> <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com> <20090526132351.9805f1e8.akpm@linux-foundation.org> <20090527115748.9ff0bad1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527115748.9ff0bad1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, May 27, 2009 at 11:57:48AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 26 May 2009 13:23:51 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > > Please note that we have to keep the FIRMWARE_NAME_MAX definition around as
> > > > some drivers rely on it.
> > > 
> > > I think the 6 files should be converted, and FIRMWARE_NAME_MAX
> > > removed, otherwise people will keep copying that crap around.
> > > 
> > >   drivers/pcmcia/ds.c
> > >   drivers/usb/atm/ueagle-atm.c
> > >   drivers/net/wireless/libertas/if_usb.c
> > >   drivers/net/wireless/libertas/if_spi.c
> > >   drivers/media/dvb/dvb-usb/dvb-usb.h
> > >   drivers/media/common/tuners/tuner-xc2028.c
> > 
> > Yep.
> 
> $ git grep -l -w FIRMWARE_NAME_MAX next-20090526 
> next-20090526:drivers/base/firmware_class.c
> next-20090526:drivers/media/common/tuners/tuner-xc2028.c
> next-20090526:drivers/media/dvb/dvb-usb/dvb-usb.h
> next-20090526:drivers/net/wireless/libertas/if_spi.c
> next-20090526:drivers/net/wireless/libertas/if_usb.c
> next-20090526:drivers/net/wireless/p54/p54usb.c
> next-20090526:drivers/pcmcia/ds.c
> next-20090526:drivers/usb/atm/ueagle-atm.c
> next-20090526:include/linux/firmware.h
All of those have been taken care of by my last patch set, see:
http://lkml.org/lkml/2009/5/26/518

The p54usb one has been sent to John and linux-wireless as it's coming from
wireless-testing.


> next-20090526:samples/firmware_class/firmware_sample_firmware_class.c
Do I really need to fix this one too ?

Cheers,
Samuel.
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
