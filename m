Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbXJVPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbXJVPdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXJVPd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:33:28 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:33646 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbXJVPd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:33:27 -0400
Date: Mon, 22 Oct 2007 19:33:23 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071022153323.GA8123@pazke.donpac.ru>
Mail-Followup-To: Chris Bergeron <chris@pcburn.com>,
	linux-kernel@vger.kernel.org
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru> <471689DA.4070008@pcburn.com> <20071018055755.GA9561@pazke.donpac.ru> <47179116.2070505@pcburn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <47179116.2070505@pcburn.com>
X-Uname: Linux 2.6.22-2-amd64 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 291, 10 18, 2007 at 01:00:06 -0400, Chris Bergeron wrote:
> Andrey Panin wrote:
>> On 290, 10 17, 2007 at 06:16:58 -0400, Chris Bergeron wrote:
>>  =20
>>> Andrey Panin wrote:
>>>    =20
>>>> Is it possible to connect two ports and run getty on one port and=20
>>>> minicom on
>>>> another ? We should check that UARTs are really working.
>>>>
>>>>        =20
>>> I used the on-board serial port as a known working control (after getti=
ng=20
>>> it to work with the other onboard serial port) to try and connect over =
to=20
>>> one of the Syba card ports (using Cutecom & getty).  The lines light up=
,=20
>>> but there's nothing getting sent from the 8-port as far as I can see.
>>>    =20
>>
>> Oh crap... I missed this fscking "Disabling IRQ #17" line in your dmesg.
>> Can you try with firewire controller disabled somehow ?
>>
>>  =20
> Ah, I forgot to make note of that.  I did actually turn off Firewire in t=
he=20
> BIOS.  Assuming that worked (and it looks like it did) the following=20
> section probably contains the relevant bits.  Still getting the IRQ 17=20
> error.
>
> -- Chris
>
> PCI: Setting latency timer of device 0000:00:05.0 to 64
> NET: Registered protocol family 17
> eth0: no IPv6 routers present
> irq 17: nobody cared (try booting with the "irqpoll" option)
> [<c0104f45>] show_trace_log_lvl+0x1a/0x2f
> [<c0105939>] show_trace+0x12/0x14
> [<c0105951>] dump_stack+0x16/0x18
> [<c0152f90>] __report_bad_irq+0x39/0x79
> [<c01531af>] note_interrupt+0x1df/0x218
> [<c0153754>] handle_fasteoi_irq+0x91/0xb6
> [<c0105fef>] do_IRQ+0x7c/0x95
> [<c0104946>] common_interrupt+0x2e/0x34
> [<c010233a>] cpu_idle+0x1c/0xc2
> [<c02deed9>] rest_init+0x4d/0x4f
> [<c03e7979>] start_kernel+0x32a/0x332
> [<00000000>] 0x0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> handlers:
> [<c023ecae>] (serial8250_interrupt+0x0/0x115)
> Disabling IRQ #17
> hda: DMA timeout retry
>
>
> full dmesg output at=20
> http://pcburn.com/files/Syba_serial_controller/dmesg_with_1394_disabled.t=
xt

So the card probably generates screaming interrupt... that's bad.
I found some docs for IT887x chips, according to these docs  IT887x
have simple interrupt controller inside. Further investigation is needed.

Can you post output of lspci -xxx ?

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHHMLDIWZCBzwS8mkRAg85AJ9KbJ+Buf9mrmN1jyVO5solIP25PwCcCpNa
1ndW7rV+1X5/99225iJW03Y=
=kt1n
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
