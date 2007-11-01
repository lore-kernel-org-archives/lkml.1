Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbXKAKDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbXKAKDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXKAKCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:02:53 -0400
Received: from twin.jikos.cz ([213.151.79.26]:45533 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbXKAKCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:02:53 -0400
Date: Thu, 1 Nov 2007 11:02:47 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: =?ISO-8859-2?Q?Marcin_=A6lusarz?= <marcin.slusarz@gmail.com>
cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: usbserial.ko/option.ko on 2.6.23: Unable to handle kernel paging
 request && inconsistent lock state
In-Reply-To: <4bacf17f0711010259q52db983dqa7fc1f25e6a859d4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711011102090.4152@twin.jikos.cz>
References: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com> 
 <Pine.LNX.4.64.0710300838280.18815@twin.jikos.cz>
 <4bacf17f0711010259q52db983dqa7fc1f25e6a859d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-2121414605-1193911367=:4152"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-2121414605-1193911367=:4152
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 1 Nov 2007, Marcin =A6lusarz wrote:

> > > swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> > >  (&port->lock){+...}, at: [<ffffffff880e212c>]
> > > usb_serial_generic_read_bulk_callback+0x6c/0x1c0 [usbserial]
> > > {hardirq-on-W} state was registered at:
> > The fix for this one has already been submitted to Greg --
> > http://lkml.org/lkml/2007/10/28/38
> with this patch I still get:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 2.6.23 #9
> ---------------------------------
> inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (&port->lock){+...}, at: [<ffffffff880e912d>]
> usb_serial_generic_read_bulk_callback+0x6d/0x1d0 [usbserial]
> {hardirq-on-W} state was registered at:
>   [<ffffffff80251273>] __lock_acquire+0x703/0x1110
>   [<ffffffff880e93b6>] usb_serial_generic_write+0x76/0x2e0 [usbserial]

What kernel version are you using? I should have already fixed this one in=
=20
current git -- commit acd2a847

--=20
Jiri Kosina
---1747641777-2121414605-1193911367=:4152--
