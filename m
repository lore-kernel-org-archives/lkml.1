Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231Ab0AWMrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0AWMrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 07:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916Ab0AWMrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 07:47:17 -0500
Received: from senator.holtmann.net ([87.106.208.187]:45170 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab0AWMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 07:47:16 -0500
Subject: Re: [PATCH 31/31] CAPI: Officially claim char major 191
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Kiszka <jan.kiszka@web.de>, David Miller <davem@davemloft.net>,
       Karsten Keil <isdn@linux-pingi.de>, linux-kernel@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de, isdn4linux@listserv.isdn4linux.de,
       netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>
In-Reply-To: <20100123122430.5a078b4a@lxorguk.ukuu.org.uk>
References: <cover.1264201406.git.jan.kiszka@web.de>
	 <445e1bf881b6f8b6a5886d6eee70f6435a5619d6.1264201408.git.jan.kiszka@web.de>
	 <20100123122430.5a078b4a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 13:48:12 +0100
Message-ID: <1264250892.3469.52.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> > I found no trace of this mysterious "pcl181" device, neither in-tree nor
> > out there in the wild. At the same time, the in-tree CAPI middleware is
> > using major 191 for many years now and obviously without any conflict.
> > Let's officially claim this major number.
> 
> This is not the way it should have been done but whoever needs spanking
> got away with it years ago. Given that this seems the best way forward.
> 
> With LANANA hat on

actually in the days of udev, the capifs is not really needed anymore.
The right choice would be to remove it. I haven't been enabling it since
years.

Regards

Marcel


