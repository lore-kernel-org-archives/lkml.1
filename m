Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbXLVHWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbXLVHWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 02:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXLVHWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 02:22:11 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43350 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751059AbXLVHWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 02:22:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=0mtTNuVyGkEDadX6+HyUknrvBZDxoUdCXxezxj88RIUmY3R0PT/Cc1LCU0iH/0NI7aYCzAZApyFGptqbVMq6UhEHklRxqIj03kWztr83Ee/rJ/YLTO0jHOtI9orLZONBDw0y9StlLe5K+F1pinosd2NGtod8FlzN6G9YNcLX/e4=  ;
X-YMail-OSG: ibbtAUMVM1kblZ_NjwwHIQkI5wFmtcjtVO6eHzr1s21vmsmnSjZLGVgWOydAW3MQz1uiTZOpjQ--
Date: Fri, 21 Dec 2007 23:22:08 -0800
From: David Brownell <david-b@pacbell.net>
To: jengelh@computergmbh.de, a1426z@gawab.com
Subject: Re: [RFC] USB Kconfig: Declutter USB Kconfig Menu
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
References: <200712211630.03426.a1426z@gawab.com>
 <200712220806.24730.a1426z@gawab.com>
 <20071222061919.A5B1D1915EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <200712220951.57634.a1426z@gawab.com>
In-Reply-To: <200712220951.57634.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071222072208.A0960230DE8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Which is why my suggestion was to have them both move up a level, with
> > host and peripheral side menus nested normally:
> >
> > 	Device Drivers:
> > 		...
> > 		[ ] HID devices
> > 		< > Host side USB
> > 		< > Peripheral side USB
> > 		< > MMC/SD/SDIO card support
> > 		[ ] LED support
> > 		...
> >
> > That way both host and peripheral side support would have their own
> > menu, and that pointless nesting would be reduced.
>
> You mean:
>  		[ ] Host side USB
>  		[ ] Peripheral side USB
>
> Right?

Both of those subsystems are already set up with the main choice
as tristate "< >/<M>/<*>".  If we're simplifying the navigation,
I can't see a point to requiring *two* menu actions not one.

- Dave

