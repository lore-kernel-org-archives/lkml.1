Return-Path: <linux-kernel-owner+w=401wt.eu-S1422715AbXBURf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422715AbXBURf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422728AbXBURf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:35:58 -0500
Received: from smtp-msa-out01.orange.fr ([193.252.23.120]:34127 "EHLO
	smtp-msa-out01.orange.fr" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422715AbXBURf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:35:57 -0500
X-Greylist: delayed 12832 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 12:35:57 EST
X-ME-UUID: 20070221173556365.08E617000090@mwinf2352.orange.fr
X-ME-User-Auth: jean-luc.coulon
Date: Wed, 21 Feb 2007 18:35:49 +0100
From: "Jean-Luc Coulon (f5ibh)" <jean-luc.coulon@wanadoo.fr>
Subject: Re: 2.6.20-git and 2.6.21-rc1, failed to boot on sata_via
To: linux-kernel@vger.kernel.org
References: <1172066520l.8209l.0l@tangerine>
	<20070221161823.GA5011@gentoox2.trippelsdorf.de>
In-Reply-To: <20070221161823.GA5011@gentoox2.trippelsdorf.de> (from
	markus@trippelsdorf.de on Wed Feb 21 17:18:23 2007)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEV7e3v8/Pzy8vKqqqr/
	//9AQEDV1dUSEhK4Ewz8AAACVElEQVQ4jWWUTW/bMAyGiRpuzlaNnhO11VmtFu2cQD/AWKDp
	2kqtei1QePr7e0k7yYDxZj4iX35IpkFsH1MTmzN/Kq1J/NsY22qnHYNhAapP7WI3S4iA7dnP
	cV87IQzU/uzvLI68MJCIu1Vg9tngzO8FjIP6EDDH292oSlpzUYB0ZHfsHkM4IGR+W8Fdohhp
	Yn84GqhIXUj19FWIrN/BHwbj0iIC8PldnS85CLiHyJ9hOCCV2pyKq1UCoFF6Vgc4qDQ5n/P4
	H7hvAHXJFAIDlBUAtgDuAlijAQQB3RVwVe05XIEOq4bbtPZrBTNHjGsq169gAGB1Lvega3UW
	Y5SIBwZoROvqKFLn0nwrwCQuyznveBk4lCY/MtCbNlGcp67w9Gdym5MXDf2zyRU5GVyVOZHr
	6QJk5V/adkTQsFRFQ38ymOO3crZDecX6LEAxiFM/aV+402KrRAT11FKciKbsa81aF6pmAdsW
	kZum6qveYSa0RBzUgwA7Gef1eESXVao6DCZFcs6eAPKoqiX/skSYNK/A5Z0GqO8L0D3adnZy
	PGRTlzbQoDI9RBw1St0C3sIasWd1rDqecjXF2vczeMVMARr5XGtxK8AbqT0a7FPsPN88RyvA
	guo+9pF35MgVSz+u4EMALHaO/gWvsW/LU8DQ6VmA1gaKkRIKsGgUG3m5ghqniPNxwkosahgF
	wA91rJczsb60SOKHCBsJ8K8RKyTxQwR52A0NLPJ+PIMq5Yq/q+Xm+HgBNvJ6O0vxNpv3g76A
	kmYmGA7+AiGo8QI23B8Mo8f9Pua/poMbvka+1JsAAAAASUVORK5CYII=
X-Mailer: Balsa 2.3.14
Message-Id: <1172079354l.6972l.0l@tangerine>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	protocol="application/pgp-signature"; boundary="=-brYv6o8uL3pJNsBOxYLM"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-brYv6o8uL3pJNsBOxYLM
Content-Type: text/plain; charset=iso-8859-15; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Le 21.02.2007 17:18:23, Markus Trippelsdorf a =E9crit=A0:
> On Wed, Feb 21, 2007 at 03:01:54PM +0100, Jean-Luc Coulon (f5ibh)
> wrote:
>>=20
>> At boot time, I've the following messages:
>>=20
>> ACPI: PCI Interrupt 0000:00:0f.0[B] GSI 20(level, low) -> IRQ 20
>> sata_via 0000:00:0f.0: failed on iomap PCI BAR 0
>> sata_via 0000:00:0f.0: out of memory
>> ACPI: PCI interrupt for device 0000:00:0f.0 is disabled
>> sata_via: probe of 0000:00:0f.0 failed with error -12
>=20
> I had the same problem, but the issue is already fixed. See:
> http://www.mail-archive.com/linux-ide@vger.kernel.org/msg03945.html

Thanks Markus. I've applied the patch (and it works :)
I was puzzled because rc1 has been released today without this patch.

Regards

Jean-Luc

--=-brYv6o8uL3pJNsBOxYLM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF3IL5UdGGXzzGnNARAvX8AJ0d0HRyzh44AoEZysPsrX43Vl9VMACeLF88
rWL570xDHZMTo1OZr4GdkAc=
=66qM
-----END PGP SIGNATURE-----

--=-brYv6o8uL3pJNsBOxYLM--

