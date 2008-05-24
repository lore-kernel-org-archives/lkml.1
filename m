Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYEXBKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYEXBKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYEXBKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:10:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12281 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYEXBJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=UE6SypdC7fH/LiTKWgzTF/3ju1wSSX1L4DY5qbZsrFmCA9uV9u8oWXflSMlGCtq6mfkX1luzn5z8da8WLo78mGudMrWRwaik11+hX3W7vHkKuvx+QXE569hZgCZh05IGEWE4lyGQi6DMn8iWMlCtVA8UgkGieQChk1tkFM7UV2E=
Date: Sat, 24 May 2008 02:09:50 +0100
From: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr
 after e820_reserve_resources
Message-ID: <20080524020950.1538624a@snowcone>
In-Reply-To: <86802c440805231705g534e9245oc359dc316ae5b1cd@mail.gmail.com>
References: <20080518014111.4f32298b@googlemail.com>
	<20080518232347.7964835c@snowcone>
	<86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	<20080520014405.5eb150cd@googlemail.com>
	<86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	<20080520022446.3b9c335a@googlemail.com>
	<86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
	<20080520041655.0552236d@googlemail.com>
	<86802c440805192022n29e191dfped3ee5afa7894288@mail.gmail.com>
	<20080524005021.67b98674@snowcone>
	<86802c440805231705g534e9245oc359dc316ae5b1cd@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zJ4/+3CIymyNShjijjhsJGx";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zJ4/+3CIymyNShjijjhsJGx
Content-Type: multipart/mixed; boundary="MP_/2AlIvHwc55xUh=g1dkRxHpi"

--MP_/2AlIvHwc55xUh=g1dkRxHpi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 23 May 2008 17:05:34 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> > Without the ram_reserve
> > patch, /proc/iomem is as it was earlier in the discussion.
> >
> >> can you boot with pnpacpi=3Doff ?
> >
> > No, that doesn't help either.
>
> how about /proc/iomem with pnpacpi=3Doff?

I've attached /proc/iomem from current head minus the original patch,
with and without pnpacpi=3Doff.

Thanks,
--=20
Ciaran McCreesh

--MP_/2AlIvHwc55xUh=g1dkRxHpi
Content-Type: text/plain; name=iomem-normal.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=iomem-normal.txt

00000000-0009ffff : pnp 00:09
000f0000-000fffff : pnp 00:09
00100000-d7feffff : pnp 00:09
d7ff0000-d7ffffff : pnp 00:09
d8000000-dfffffff : PCI Bus 0000:01
  d8000000-dfffffff : 0000:01:05.0
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : pnp 00:08
fdb00000-fdbfffff : PCI Bus 0000:03
fdc00000-fdcfffff : PCI Bus 0000:03
  fdcff000-fdcff0ff : 0000:03:05.0
    fdcff000-fdcff0ff : 8139too
fdd00000-fddfffff : PCI Bus 0000:02
  fdd00000-fdd1ffff : 0000:02:00.0
fde00000-fdefffff : PCI Bus 0000:02
  fdeff000-fdefffff : 0000:02:00.0
    fdeff000-fdefffff : r8169
fdf00000-fdffffff : PCI Bus 0000:01
  fdf00000-fdf03fff : 0000:01:05.2
    fdf00000-fdf03fff : ICH HD audio
  fdff0000-fdffffff : 0000:01:05.0
fe024000-fe027fff : 0000:00:14.2
  fe024000-fe027fff : ICH HD audio
fe029000-fe0290ff : 0000:00:13.5
  fe029000-fe0290ff : ehci_hcd
fe02a000-fe02afff : 0000:00:13.4
  fe02a000-fe02afff : ohci_hcd
fe02b000-fe02bfff : 0000:00:13.3
  fe02b000-fe02bfff : ohci_hcd
fe02c000-fe02cfff : 0000:00:13.2
  fe02c000-fe02cfff : ohci_hcd
fe02d000-fe02dfff : 0000:00:13.1
  fe02d000-fe02dfff : ohci_hcd
fe02e000-fe02efff : 0000:00:13.0
  fe02e000-fe02efff : ohci_hcd
fe02f000-fe02f3ff : 0000:00:12.0
  fe02f000-fe02f3ff : ahci
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:09
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : 0000:00:14.0
    fed00000-fed000ff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:09
ffff0000-ffffffff : pnp 00:09
100000000-11fffffff : System RAM
  00200000-005d356d : Kernel code
  005d356e-00770927 : Kernel data
  007df000-0085f74f : Kernel bss

--MP_/2AlIvHwc55xUh=g1dkRxHpi
Content-Type: text/plain; name=iomem-pnpacpi-off.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=iomem-pnpacpi-off.txt

d8000000-dfffffff : PCI Bus 0000:01
  d8000000-dfffffff : 0000:01:05.0
e0000000-efffffff : PCI MMCONFIG 0
fdb00000-fdbfffff : PCI Bus 0000:03
fdc00000-fdcfffff : PCI Bus 0000:03
  fdcff000-fdcff0ff : 0000:03:05.0
    fdcff000-fdcff0ff : 8139too
fdd00000-fddfffff : PCI Bus 0000:02
  fdd00000-fdd1ffff : 0000:02:00.0
fde00000-fdefffff : PCI Bus 0000:02
  fdeff000-fdefffff : 0000:02:00.0
    fdeff000-fdefffff : r8169
fdf00000-fdffffff : PCI Bus 0000:01
  fdf00000-fdf03fff : 0000:01:05.2
    fdf00000-fdf03fff : ICH HD audio
  fdff0000-fdffffff : 0000:01:05.0
fe024000-fe027fff : 0000:00:14.2
  fe024000-fe027fff : ICH HD audio
fe029000-fe0290ff : 0000:00:13.5
  fe029000-fe0290ff : ehci_hcd
fe02a000-fe02afff : 0000:00:13.4
  fe02a000-fe02afff : ohci_hcd
fe02b000-fe02bfff : 0000:00:13.3
  fe02b000-fe02bfff : ohci_hcd
fe02c000-fe02cfff : 0000:00:13.2
  fe02c000-fe02cfff : ohci_hcd
fe02d000-fe02dfff : 0000:00:13.1
  fe02d000-fe02dfff : ohci_hcd
fe02e000-fe02efff : 0000:00:13.0
  fe02e000-fe02efff : ohci_hcd
fe02f000-fe02f3ff : 0000:00:12.0
  fe02f000-fe02f3ff : ahci
fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : 0000:00:14.0
fee00000-fee00fff : Local APIC
100000000-11fffffff : System RAM
  00200000-005d356d : Kernel code
  005d356e-00770927 : Kernel data
  007df000-0085f74f : Kernel bss

--MP_/2AlIvHwc55xUh=g1dkRxHpi--

--Sig_/zJ4/+3CIymyNShjijjhsJGx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkg3auAACgkQ96zL6DUtXhEG+QCfdfDwQxBVy9MVYCyn0LV72d+j
YSIAoLQvVFpOP3g3A4WkYiFy2qgsvjvI
=hP9o
-----END PGP SIGNATURE-----

--Sig_/zJ4/+3CIymyNShjijjhsJGx--
