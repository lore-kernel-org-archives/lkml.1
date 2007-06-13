Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbXFMQR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbXFMQR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbXFMQRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:17:22 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36411 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbXFMQRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:17:21 -0400
Date: Wed, 13 Jun 2007 18:17:16 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Islam Amer <pharon@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
In-Reply-To: <1181750326.6163.6.camel@iamer-laptop>
Message-ID: <Pine.LNX.4.64.0706131809530.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro> 
 <1181563063.19258.11.camel@iamer-laptop>  <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
  <1181743734.6163.1.camel@iamer-laptop>  <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
  <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com> 
 <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz> <1181750326.6163.6.camel@iamer-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Islam Amer wrote:

> Nevertheless the patch you sent got the "TXT" key to work but not the 
> "BACK" key. Here are the codes for all of the non-functioning keys ( TXT 
> , BACK , 4 COLOR keys ):

You should also be obtaining hid-debug dump of usage code -> input mapping 
when the kernel is compiled with CONFIG_HID_DEBUG, just after the report 
descriptor is dumped, something like

drivers/hid/usbhid/hid-core.c: report descriptor (size 55, read 55) = 05 
01 09 02 a1 01 09 01 a1 00 05 09 19 01 29 08 15 00 25 01 75 01 95 08 81 02 
05 01 09 30 09 31 09 38 15 81 25 7f 75 08 95 03 81 06 05 0c 0a 38 02 95 01 
81 06 c0 c0
  INPUT[INPUT]
    Field(0)
      Physical(GenericDesktop.Pointer)
      Usage(8)
        Button.0001
        Button.0002
        Button.0003
        Button.0004
... etc.

Could you please send it to me, it wasn't included in your previous dump 
you sent me?

Thanks,

-- 
Jiri Kosina
