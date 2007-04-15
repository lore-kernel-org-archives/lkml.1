Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXDONba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXDONba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 09:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXDONba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 09:31:30 -0400
Received: from dhuumrelay0.dtm.ops.eu.uu.net ([194.139.33.69]:41872 "EHLO
	dhuumrelay0.dtm.ops.eu.uu.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbXDONba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 09:31:30 -0400
X-Authenticated-As: win1683552@knuut.de at dhuumrelay0.dtm.ops.eu.uu.net 
From: Ulrich Eckhardt <doomster@knuut.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] use C99 initialisers for PCI_VDEVICE()
Date: Sun, 15 Apr 2007 15:32:38 +0200
User-Agent: KMail/1.9.5
References: <200704151234.37463.doomster@knuut.de> <46222051.9010104@garzik.org>
In-Reply-To: <46222051.9010104@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151532.39682.doomster@knuut.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 14:53, Jeff Garzik wrote:
> Ulrich Eckhardt wrote:
> > (Note: CC me please, I'm not subscribed.)
[...]
> > -#define PCI_VDEVICE(vendor, device)            \
> > -       PCI_VENDOR_ID_##vendor, (device),       \
> > -       PCI_ANY_ID, PCI_ANY_ID, 0, 0
> > +#define PCI_VDEVICE(vend, dev)         \
> > +       .vendor=PCI_VENDOR_ID_##vend, .device=(dev),    \
> > +       .subvendor=PCI_ANY_ID, .subdevice=PCI_ANY_ID,   \
> > +       .class=0, .class_mask=0
>
> NAK.  C99 initializers were intentionally avoided.  Look at the usage of
> this macro.

I'm aware of the uses and documentation of this, I was just under the 
impression that C99 initialisers were the agreed way to go because of their 
resistance against reording of fields. Of course, if that assumption is 
wrong, this patch is moot anyway.

Am I generally wrong or is this case an intentional exception?

Uli
