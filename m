Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZHFGRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZHFGRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZHFGRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:17:35 -0400
Received: from senator.holtmann.net ([87.106.208.187]:32925 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZHFGRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:17:34 -0400
Subject: Re: [PATCH] pci_ids.h: add new Atheros USB vendor ID
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       zhifeng.cai@atheros.com, stephen.chen@atheros.com,
       linux-usb@vger.kernel.org
In-Reply-To: <20090806050932.GA25015@kroah.com>
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
	 <1249532170.21101.3.camel@localhost.localdomain>
	 <43e72e890908052126v53aa1b4sb7a48e19f98fdfa6@mail.gmail.com>
	 <1249533357.21101.5.camel@localhost.localdomain>
	 <20090806050932.GA25015@kroah.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 23:17:27 -0700
Message-Id: <1249539447.21101.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luiz,

> > > >> New Atheros USB devices will use 0x0cf3. The first device
> > > >> will be ar9271, for which we are adding support for.
> > > >>
> > > >> Cc: zhifeng.cai@atheros.com
> > > >> Cc: stephen.chen@atheros.com
> > > >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > > >> ---
> > > >>
> > > >> John, sending this through you as this is only
> > > >> specific to wireless, at least at the moment.
> > > >>
> > > >>  include/linux/pci_ids.h |    1 +
> > > >>  1 files changed, 1 insertions(+), 0 deletions(-)
> > > >>
> > > >> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > > >> index 73b46b6..27f4e6b 100644
> > > >> --- a/include/linux/pci_ids.h
> > > >> +++ b/include/linux/pci_ids.h
> > > >> @@ -2170,6 +2170,7 @@
> > > >>  #define PCI_DEVICE_ID_BCM1250_HT     0x0002
> > > >>
> > > >>  #define PCI_VENDOR_ID_ATHEROS                0x168c
> > > >> +#define PCI_VENDOR_ID_ATHEROS_USB    0x0cf3
> > > >
> > > > this is confusing the hell out of me. What are you adding here.
> > > 
> > > No you're right, my fault.
> > > 
> > > > A USB
> > > > vendor id or a PCI one. Is the ar9271 a PCI device or a USB device?
> > > 
> > > Its only USB.
> > > 
> > > Thanks... hm I see no USB vendor id headers. Guess we won't need to add this.
> > 
> > the closest we have is drivers/hid/hid-ids.h and we might just should
> > have Greg create a usb-ids.h file.
> 
> Ick, no, there's no such file for a good reason.  Put your device ids in
> the driver files, no need to share it across the whole kernel.

that is fine with me btw. I have always done this. I do actually prefer
the plain ids and then a comment above their usage :)

Regards

Marcel


