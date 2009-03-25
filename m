Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZCZRlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZCZRlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZCZRk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:40:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54769 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZCZRk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:40:56 -0400
Subject: Re: 2.6.29-rc5+: usb bluetooth crashes system
From: Marcel Holtmann <marcel@holtmann.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <200903261311.03513.oliver@neukum.org>
References: <20090310112307.GD1337@ucw.cz>
	 <20090319225011.GB6314@elf.ucw.cz> <20090326095856.GA22641@elf.ucw.cz>
	 <200903261311.03513.oliver@neukum.org>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 17:22:54 +0100
Message-Id: <1237998174.13998.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> > > Well, I took btusb.c from 2.6.28 and that fixed the issue; so we know
> > > the regression is in btusb.c file between 28 and 29-rc7. If you have
> > > specific version of btusb.c you want me to test, please mail it to me.
> >
> > This smaller patch (partial revert of btusb.c to 2.6.28 state) seems
> > to help, too....
> 
> Could you test whether reversing the changes to btusb_probe() alone
> helps?

just test net-next-2.6 or latest Linus' tree once he pulled the
networking changes from Dave.

We had to partly revert that change for some hardware. Believe it or
not, but some Bluetooth chips don't work if we don't submit the bulk
URBs along with the interrupt URBs.

Regards

Marcel


