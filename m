Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbYHCUSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbYHCUSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbYHCUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:18:11 -0400
Received: from xenotime.net ([66.160.160.81]:39999 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753942AbYHCUSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:18:10 -0400
Date: Sun, 3 Aug 2008 13:18:05 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
cc: Manish Katiyar <mkatiyar@gmail.com>, kernel-janitors@vger.kernel.org,
       astarikovskiy@suse.de, vladimir.p.lebedev@intel.com,
       LKML <linux-kernel@vger.kernel.org>, trivial@vger.kernel.org
Subject: Re: [PATCH] Remove warning 'unused variable battery' in drivers/acpi/sbs.c
In-Reply-To: <Pine.LNX.4.64.0808031528420.31606@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0808031317280.14866@shark.he.net>
References: <ea11fea30808030024v18912201x46d12fe389e508f8@mail.gmail.com>
 <Pine.LNX.4.64.0808031528420.31606@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1606286688-1594044552-1217794685=:14866"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1606286688-1594044552-1217794685=:14866
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 3 Aug 2008, Ilpo J=E4rvinen wrote:

> On Sun, 3 Aug 2008, Manish Katiyar wrote:
>=20
> > Below patch removes the following warning:
> > drivers/acpi/sbs.c: In function 'acpi_battery_remove':
> > drivers/acpi/sbs.c:819: warning: unused variable 'battery'
> >=20
> >=20
> >=20
> > Signed-off-by:- "Manish Katiyar" <mkatiyar@gmail.com>
> >=20
> > ---
> >  drivers/acpi/sbs.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
> > index 10a3651..8493603 100644
> > --- a/drivers/acpi/sbs.c
> > +++ b/drivers/acpi/sbs.c
> > @@ -816,7 +816,9 @@ static int acpi_battery_add(struct acpi_sbs *sbs, i=
nt id)
> >=20
> >  static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
> >  {
> > +#ifdef CONFIG_ACPI_SYSFS_POWER || CONFIG_ACPI_PROCFS_POWER
>=20
> I don't think you can use || operator in ifdef like that... ...Try
> #if defined(...) || (...) instead.


Did the patch sumbitter try to build this with the patch in place???

--=20
~Randy
---1606286688-1594044552-1217794685=:14866--
