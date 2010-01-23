Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772Ab0AWOY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0AWOY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 09:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649Ab0AWOY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 09:24:58 -0500
Received: from senator.holtmann.net ([87.106.208.187]:44242 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0AWOY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 09:24:57 -0500
Subject: Re: [PATCH 31/31] CAPI: Officially claim char major 191
From: Marcel Holtmann <marcel@holtmann.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       Karsten Keil <isdn@linux-pingi.de>, linux-kernel@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de, isdn4linux@listserv.isdn4linux.de,
       netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>
In-Reply-To: <4B5AF5FF.6050702@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
	 <445e1bf881b6f8b6a5886d6eee70f6435a5619d6.1264201408.git.jan.kiszka@web.de>
	 <20100123122430.5a078b4a@lxorguk.ukuu.org.uk>
	 <1264250892.3469.52.camel@violet>  <4B5AF5FF.6050702@web.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 15:25:53 +0100
Message-ID: <1264256753.3469.55.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

> >>> I found no trace of this mysterious "pcl181" device, neither in-tree nor
> >>> out there in the wild. At the same time, the in-tree CAPI middleware is
> >>> using major 191 for many years now and obviously without any conflict.
> >>> Let's officially claim this major number.
> >> This is not the way it should have been done but whoever needs spanking
> >> got away with it years ago. Given that this seems the best way forward.
> >>
> >> With LANANA hat on
> > 
> > actually in the days of udev, the capifs is not really needed anymore.
> > The right choice would be to remove it. I haven't been enabling it since
> > years.
> 
> First of all, the capifs story is orthogonal to the major claim.

my point here is merely that when using udev, you need to fixed assigned
major number. Dynamic major numbers will just work fine.

> But basically you are right, capifs is likely not needed anymore. The
> only user visible change - and that was holding me back to suggest its
> removal - is the time when the NCCI minor ttys show up under /dev/capi/
> (or wherever you direct them to). If I didn't miss something about udev,
> it will make all possible minors pop up once the major is registered.
> However, I'm not sure if there is some userland actually relying on this.

That is just an issue with the current code. There is no requirement to
create all minors are at the same. You can create/remove minors on
demand as you please. And udev will take care of the device nodes for
you.

Regards

Marcel


