Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXECH47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXECH47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXECH47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:56:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:48413 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbXECH46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:56:58 -0400
Date: Thu, 3 May 2007 09:56:47 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: =?ISO-8859-1?Q?No=E8l_K=F6the?= <noel@debian.org>
cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel option CONFIG_USB_HIDINPUT_POWERBOOK description
 update
In-Reply-To: <1178118015.4820.26.camel@mbp.domain.lan>
Message-ID: <Pine.LNX.4.64.0705030951520.16923@twin.jikos.cz>
References: <1178118015.4820.26.camel@mbp.domain.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-1931157655-1178179007=:16923"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-1931157655-1178179007=:16923
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 2 May 2007, No?l K=F6the wrote:

> The description of this option needs to be extended to be correct:)
> --- /usr/src/linux-2.6.21/drivers/usb/input/Kconfig     2007-04-27 18:02:=
46.000000000 +0200
> +++ Kconfig.new 2007-05-02 16:47:56.000000000 +0200
> @@ -28,12 +28,12 @@
>         depends on USB_HID && INPUT=3Dn
> =20
>  config USB_HIDINPUT_POWERBOOK
> -       bool "Enable support for iBook/PowerBook special keys"
> +       bool "Enable support for iBook/PowerBook/MacBook/MacBookPro speci=
al keys"

Hi,

I will apply this into my tree, thanks.

> This option is needed on the Apple Intel Laptops, too. I would suggest=20
> to rename USB_HIDINPUT_POWERBOOK because its needed on Apple Laptops.=20
> Maybe USB_HIDINPUT_APPLELAPTOPS or something like this. Is a renaming=20
> patch for this welcome?

The problem here is backwards compatibility - if we would like to do the=20
change in a consistent way, we should rename all the places which (for=20
historic reasons) mention powerbook only. Unfortunately this would also=20
require renaming the module parameter hid_pb_fnmode, which might be a=20
little too intrusive with respect to maintaining backward compatibility in=
=20
userspace (ok, we have already been fiddling with this parameter anyway=20
during the usbhid code split, but anyway).

If you would care to make the patch which maintains backwards=20
compatibility (for example by aliasing the variable pb_fnmode behing two=20
module parameters), that might probably be ok.

Thanks,

--=20
Jiri Kosina
---1747641777-1931157655-1178179007=:16923--
