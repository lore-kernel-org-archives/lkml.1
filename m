Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXKAE5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXKAE5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXKAE5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:57:06 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:34598 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbXKAE5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:57:05 -0400
Subject: Re: [PATCH]bluetooth: hci_sysfs connection bus_id add support for
	diffrent hci device
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <a8e1da0710311920sa7db787s604f154f201d3a1@mail.gmail.com>
References: <20071031023017.GA3896@darkstar.te-china.tietoenator.com>
	 <20071031.000141.241824894.davem@davemloft.net>
	 <1193817409.32459.10.camel@violet>
	 <a8e1da0710310213r1e4f3d7ckcbdf2e6bf854745e@mail.gmail.com>
	 <1193824773.32459.22.camel@violet>
	 <a8e1da0710311805l32282ce0ve9df9280cf7cce06@mail.gmail.com>
	 <a8e1da0710311920sa7db787s604f154f201d3a1@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 05:56:50 +0100
Message-Id: <1193893010.32459.104.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > > Maybe we can use this instead:
> > > >       snprintf(conn->dev.bus_id, BUS_ID_SIZE,
> > > > -                     "%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > > > +                     "%s%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > > > +                     hdev->name + 3,
> > > >                       conn->type == ACL_LINK ? "acl" : "sco",
> > > >                       ba->b[5], ba->b[4], ba->b[3],
> > > >                       ba->b[2], ba->b[1], ba->b[0]);
> > >
> > > I had a look on how other subsystems handle this case and yes, they
> > > duplicate the id number from its parent device. So I applied the
> > > attached patch to my tree.
>
> Sorry for my noise.
> Theoretically, for the "%d-%s" version, overwrite is also possible.
> 
> hdev->id is u16, imagine the id is 65535, then total length is 21.

even to reach 3 digits you have to attach 100 Bluetooth devices at the
same time. Tell me when you have done that ;)

However, as I said, we have to move to using the connection handle.

Regards

Marcel


