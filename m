Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbYEGTcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbYEGTcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYEGTcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:32:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:44998 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751138AbYEGTcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:32:18 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18UupMF6hEU9p5l6Vd/UlGWAybGpLwEKmP8EX78jw
	bXxD8tGzqOVEEM
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
From: Mirco Tischler <mt-ml@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de>
References: <1210183536.28099.10.camel@mtlp.tischlernetz>
	 <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N+TMBf8psVQqZff+NJca"
Date: Wed, 07 May 2008 21:32:14 +0200
Message-Id: <1210188734.5456.14.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N+TMBf8psVQqZff+NJca
Content-Type: multipart/mixed; boundary="=-IzcEZZYpU+nt5+Yw99Ly"


--=-IzcEZZYpU+nt5+Yw99Ly
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mi, 2008-05-07 at 21:06 +0200, Thomas Gleixner wrote:
> > [11677.490019] CPU1 is down
> > [11677.490149] Extended CMOS year: 2000
> > [11677.490149] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> > 0x7010600070106
> > [11677.490747] Back to C!
> > [11677.490952] microcode: CPU0 updated from revision 0x92 to 0x92, date
> > =3D 03132007=20
> > [11677.491065] ------------[ cut here ]------------
> > [11677.491065] WARNING: at arch/x86/kernel/rtc.c:122 mach_get_cmos_time
> > +0x9e/0x14e()
>=20
> > [11677.491065]  [<ffffffff80211cdb>] mach_get_cmos_time+0x9e/0x14e
> > [11677.491065]  [<ffffffff80211da6>] read_persistent_clock+0x1b/0x35
> > [11677.491065]  [<ffffffff8024c101>] timekeeping_resume+0xb/0x120
>=20
> Interesting. That's in the resume path.
>=20
> > I wasn't able to reproduce the warning yet, but because the commit
> > message introducing the WARN_ON says:
>=20
> This is a WARN_ON_ONCE so you only see it once per boot. Resume does
> not count :) You might change that WARN_ON_ONCE to WARN_ON to check
> whether it happens more than once.
The problem is that I am currently not able to reproduce it. I've tried
~10 suspends & resumes till now. With a reboot in between. Will try some
more testing with WARN_ON though.

> Can you please provide some details about the system ?
This is a Zepto notebook with Intel chipset (santa rosa generation) and
core2duo cpu. I'm running Ubuntu 8.04 x86_64. I attach a lspci output.
Just ask if you need more specific information.

> Thanks,
> 	tglx
Thanks
Mirco

--=-IzcEZZYpU+nt5+Yw99Ly
Content-Disposition: attachment; filename=lspci
Content-Type: text/plain; name=lspci; charset=UTF-8
Content-Transfer-Encoding: base64

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gTW9iaWxlIFBNOTY1L0dNOTY1
L0dMOTYwIE1lbW9yeSBDb250cm9sbGVyIEh1YiAocmV2IDAzKQ0KMDA6MDIuMCBWR0EgY29tcGF0
aWJsZSBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBNb2JpbGUgR005NjUvR0w5NjAgSW50
ZWdyYXRlZCBHcmFwaGljcyBDb250cm9sbGVyIChyZXYgMDMpDQowMDowMi4xIERpc3BsYXkgY29u
dHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gTW9iaWxlIEdNOTY1L0dMOTYwIEludGVncmF0ZWQg
R3JhcGhpY3MgQ29udHJvbGxlciAocmV2IDAzKQ0KMDA6MWEuMCBVU0IgQ29udHJvbGxlcjogSW50
ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAj
NCAocmV2IDAzKQ0KMDA6MWEuMSBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4
MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjNSAocmV2IDAzKQ0KMDA6MWEu
NyBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkg
VVNCMiBFSENJIENvbnRyb2xsZXIgIzIgKHJldiAwMykNCjAwOjFiLjAgQXVkaW8gZGV2aWNlOiBJ
bnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUggKElDSDggRmFtaWx5KSBIRCBBdWRpbyBDb250cm9sbGVy
IChyZXYgMDMpDQowMDoxYy4wIFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSCAo
SUNIOCBGYW1pbHkpIFBDSSBFeHByZXNzIFBvcnQgMSAocmV2IDAzKQ0KMDA6MWMuMSBQQ0kgYnJp
ZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUggKElDSDggRmFtaWx5KSBQQ0kgRXhwcmVzcyBQ
b3J0IDIgKHJldiAwMykNCjAwOjFjLjIgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4
MDFIIChJQ0g4IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCAzIChyZXYgMDMpDQowMDoxYy4zIFBD
SSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSCAoSUNIOCBGYW1pbHkpIFBDSSBFeHBy
ZXNzIFBvcnQgNCAocmV2IDAzKQ0KMDA6MWQuMCBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9y
YXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjMSAocmV2IDAz
KQ0KMDA6MWQuMSBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4
IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjMiAocmV2IDAzKQ0KMDA6MWQuMiBVU0IgQ29u
dHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kg
Q29udHJvbGxlciAjMyAocmV2IDAzKQ0KMDA6MWQuNyBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29y
cG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCMiBFSENJIENvbnRyb2xsZXIgIzEgKHJl
diAwMykNCjAwOjFlLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDEgTW9iaWxl
IFBDSSBCcmlkZ2UgKHJldiBmMykNCjAwOjFmLjAgSVNBIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRp
b24gODI4MDFIRU0gKElDSDhNKSBMUEMgSW50ZXJmYWNlIENvbnRyb2xsZXIgKHJldiAwMykNCjAw
OjFmLjEgSURFIGludGVyZmFjZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIQk0vSEVNIChJQ0g4
TS9JQ0g4TS1FKSBJREUgQ29udHJvbGxlciAocmV2IDAzKQ0KMDA6MWYuMiBTQVRBIGNvbnRyb2xs
ZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSEJNL0hFTSAoSUNIOE0vSUNIOE0tRSkgU0FUQSBB
SENJIENvbnRyb2xsZXIgKHJldiAwMykNCjAwOjFmLjMgU01CdXM6IEludGVsIENvcnBvcmF0aW9u
IDgyODAxSCAoSUNIOCBGYW1pbHkpIFNNQnVzIENvbnRyb2xsZXIgKHJldiAwMykNCjAyOjAwLjAg
RXRoZXJuZXQgY29udHJvbGxlcjogQnJvYWRjb20gQ29ycG9yYXRpb24gTmV0TGluayBCQ001Nzg3
TSBHaWdhYml0IEV0aGVybmV0IFBDSSBFeHByZXNzIChyZXYgMDIpDQowNDowMC4wIE5ldHdvcmsg
Y29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gUFJPL1dpcmVsZXNzIDQ5NjUgQUcgb3IgQUdO
IE5ldHdvcmsgQ29ubmVjdGlvbiAocmV2IDYxKQ0KMDY6MDYuMCBDYXJkQnVzIGJyaWRnZTogVGV4
YXMgSW5zdHJ1bWVudHMgUENJeHgxMiBDYXJkYnVzIENvbnRyb2xsZXINCjA2OjA2LjEgRmlyZVdp
cmUgKElFRUUgMTM5NCk6IFRleGFzIEluc3RydW1lbnRzIFBDSXh4MTIgT0hDSSBDb21wbGlhbnQg
SUVFRSAxMzk0IEhvc3QgQ29udHJvbGxlcg0KMDY6MDYuMiBNYXNzIHN0b3JhZ2UgY29udHJvbGxl
cjogVGV4YXMgSW5zdHJ1bWVudHMgNS1pbi0xIE11bHRpbWVkaWEgQ2FyZCBSZWFkZXIgKFNEL01N
Qy9NUy9NUyBQUk8veEQpDQowNjowNi4zIFNEIEhvc3QgY29udHJvbGxlcjogVGV4YXMgSW5zdHJ1
bWVudHMgUENJeHgxMiBTREEgU3RhbmRhcmQgQ29tcGxpYW50IFNEIEhvc3QgQ29udHJvbGxlcg0K



--=-IzcEZZYpU+nt5+Yw99Ly--

--=-N+TMBf8psVQqZff+NJca
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIIgO+z+diZ7c2xfgRAqvjAJ4x3CDDfhluj+tfwgufI6omkNzgPgCeK7ii
wVGripuEOY9ZAPXpvyDBX74=
=PP3B
-----END PGP SIGNATURE-----

--=-N+TMBf8psVQqZff+NJca--

