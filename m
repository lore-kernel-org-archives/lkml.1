Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYACRLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYACRLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYACRK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:10:58 -0500
Received: from outbound-mail-12.bluehost.com ([69.89.18.112]:32827 "HELO
	outbound-mail-12.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752120AbYACRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:10:57 -0500
From: "Richard D" <richard@embunus.com>
To: "'Bryan Wu'" <cooloney.lkml@gmail.com>,
       "'David Brownell'" <david-b@pacbell.net>
Cc: "'Robin Getz'" <rgetz@blackfin.uclinux.org>,
       <linux-usb-devel@lists.sourceforge.net>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
References: <200801020948.51310.rgetz@blackfin.uclinux.org>	 <200801021943.38716.david-b@pacbell.net>	 <386072610801022040ja4919bapa8a0712c1246c3f3@mail.gmail.com>	 <200801022336.10355.david-b@pacbell.net> <386072610801030005g7408f333m935c665c82d3412a@mail.gmail.com>
In-Reply-To: <386072610801030005g7408f333m935c665c82d3412a@mail.gmail.com>
Subject: RE: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Thu, 3 Jan 2008 22:34:06 +0530
Message-ID: <001c01c84e2a$ad3bceb0$07b36c10$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AchN32NaS20vL34PSAyfvuL4SVr6MwASyK/Q
Content-Language: en-us
X-Identified-User: {2260:host187.hostmonster.com:embunusc:embunus.com} {sentby:bopbeforesmtp 121.247.188.187 authed with embunus.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does all USB Host controller hardware have the ability to disable PING?

> > > 2. Do you remember the PING issue I reported in OMAP list? How do
> you
> > > think of that?
> >
> > Yes, something needs to be done.  EHCI might benefit from the same
> > kind of patch, to cope with ill-behaved usb thumb drives.
> >
> >
> > > > I have an idea: the USB_NAKLIMIT0 should be set to some value,
> when we
> > > > got NAK timeout interrupt, we can disable PING. When enumerating
> normal
> > > > USB stick, there is no NAK timeout, because PING is efficient for
> > > > handshaking. While problem USB stick will generate NAK timeout
> > > > interrupt, we disable PING for this kind of USB device
> enumeration.


