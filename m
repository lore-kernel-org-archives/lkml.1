Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXJ3HmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXJ3HmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXJ3HmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:42:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:45158 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbXJ3HmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:42:17 -0400
Date: Tue, 30 Oct 2007 08:42:10 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: =?ISO-8859-2?Q?Marcin_=A6lusarz?= <marcin.slusarz@gmail.com>
cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: usbserial.ko/option.ko on 2.6.23: Unable to handle kernel paging
 request && inconsistent lock state
In-Reply-To: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710300838280.18815@twin.jikos.cz>
References: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-1356621543-1193729941=:18815"
Content-ID: <Pine.LNX.4.64.0710300841550.18815@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-1356621543-1193729941=:18815
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0710300841551.18815@twin.jikos.cz>

On Mon, 29 Oct 2007, Marcin =A6lusarz wrote:

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 2.6.23 #8
> ---------------------------------
> inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (&port->lock){+...}, at: [<ffffffff880e212c>]
> usb_serial_generic_read_bulk_callback+0x6c/0x1c0 [usbserial]
> {hardirq-on-W} state was registered at:

The fix for this one has already been submitted to Greg --=20
http://lkml.org/lkml/2007/10/28/38

--=20
Jiri Kosina
---1747641777-1356621543-1193729941=:18815--
