Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbXJQGmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbXJQGmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXJQGmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:42:23 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:37338 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbXJQGmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:42:22 -0400
Date: Wed, 17 Oct 2007 10:42:19 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071017064219.GB1953@pazke.donpac.ru>
Mail-Followup-To: Chris Bergeron <chris@pcburn.com>,
	linux-kernel@vger.kernel.org
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <47150B06.3040306@pcburn.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 289, 10 16, 2007 at 03:03:34PM -0400, Chris Bergeron wrote:
> Andrey Panin wrote:
>> On 284, 10 11, 2007 at 01:02:12PM -0400, Chris Bergeron wrote:
>>  =20
>>> Andrey Panin wrote:
>>>    =20
>>>> On 278, 10 05, 2007 at 05:31:05PM -0400, Chris Bergeron wrote:
>>>>        =20
>>>>> Hello all,
>>>>>
>>>>> I've just installed a multiport serial card released by an outfit=20
>>>>> called Syba.  This is an 8 port serial-only card with an Octopus styl=
e=20
>>>>> breakout cable.  The main chipset on it is an ITE IT8871F.
>>>>>            =20
>>>> Are you sure ? IIRC IT887x are PCI-ISA bridges with additional periphe=
ry
>>>> and your lspci shows PLX chip. Can you send complete lspci -vv output ?
>>>> Output of dmesg could be useful too.
>>>>
>>>>      =20
>>> I'm sure that's what it says on the largest chip on the PCI card.  It=
=20
>>> could be that the other two chips are more relevant... the numbers from=
=20
>>> them are included below.
>>>
>>> I've posted up a quick text only page with the diagnostic information=
=20
>>> from the system (full dmesg, lspci, etc) plus links to pictures of the=
=20
>>> board (since others might see something important that I'm not aware of=
).=20
>>>  You can access that at=20
>>> http://pcburn.com/files/Syba_serial_controller/index.html
>>>    =20
>>
>> Can you try an attached patch ? I hope it should at least detect UARTs o=
n=20
>> your board. Be ready that baudrate could be wrong, because we do not know
>> what frequency is used to clock these UARTs.
>>
>>  =20
> Alright,finally had another machine to try the attached patch.  I get an=
=20
> odd error regarding IRQ 17:
>
> "irq 17: nobody cared (try booting with the "irqpoll" option)"

This message apearred after firewire driver initialization and firewire chip
shares IRQ with serial card. It's hard to say who is guilty here :)

> along with a long error message (but the kernel continues to load).  Asid=
e=20
> from that the ports now allow me to run a getty on them and the DTR line=
=20
> lights up on my serial tester (as it does with a working port) but the=20
> device on the other end doesn't function.

Is it possible to connect two ports and run getty on one port and minicom on
another ? We should check that UARTs are really working.

> I've updated the web page with lspci -vv and dmesg output.  I can also po=
st=20
> it here if that's desirable, just figured I'd save everyone the inbox=20
> flooding :).
>
> -- Chris

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHFa7LIWZCBzwS8mkRAikZAJ9P/7S1xk5tQppyFB+ynbEcS6GIoQCgoBI0
iakPNx059n3NzzfmJHyTL+k=
=wy80
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
