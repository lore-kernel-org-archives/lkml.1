Return-Path: <linux-kernel-owner+w=401wt.eu-S1762877AbXGQQYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762877AbXGQQYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762998AbXGQQYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:24:23 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33330 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756912AbXGQQYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:24:22 -0400
Subject: Re: [patch 0/3] reiser4 fixups
From: Zan Lynx <zlynx@acm.org>
To: Edward Shishkin <edward@namesys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <469BBE07.2010606@namesys.com>
References: <1184090582.6933.20.camel@localhost>
	 <469523FA.7010308@namesys.com>  <46968F88.7070300@acm.org>
	 <1184344914.468943.3.camel@localhost>  <469BBE07.2010606@namesys.com>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-kYcw43ms4N2E8v4vT5g4"
Date: Tue, 17 Jul 2007 10:24:16 -0600
Message-Id: <1184689456.457333.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kYcw43ms4N2E8v4vT5g4
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-0RpgR5l6YQgy70NrkTLk"


--=-0RpgR5l6YQgy70NrkTLk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-16 at 22:50 +0400, Edward Shishkin wrote:
> Zan Lynx wrote:
> ...
>=20
> >Unable to handle kernel NULL pointer dereference at 0000000000000000
> RIP:=20
> > [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
[snip]
> This is bug in Zam's new file_read: unlocked page was reclaimed,
> then reiser4_tree_by_page() looks at page->mapping->host.
> The patch #3 fixes this problem.
>=20
> Andrew, please apply the following series.

These three patches appear to have fixed my problem.  I ran it all of
last afternoon and last night, and it did not oops.

Thank you, Edward.

--=20
Zan Lynx <zlynx@acm.org>

--=-0RpgR5l6YQgy70NrkTLk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGnO0jG8fHaOLTWwgRAsbPAJwIRmu/IOZ1qcl1cFlxvPveHMPYcACcCCzi
yfibwcG5j/HQldGmpoWer4w=3D
=3DTCsi
-----END PGP SIGNATURE-----

--=-0RpgR5l6YQgy70NrkTLk--

--=-kYcw43ms4N2E8v4vT5g4
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIII8zCCAtQw
ggI9oAMCAQICEBmv7WBciYMnO0zg9KmbGQUwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDUyMjE5NDYxOVoXDTA4MDUyMTE5NDYx
OVowPzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEcMBoGCSqGSIb3DQEJARYNemx5
bnhAYWNtLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALi7cy1U27KrA5lA/KVg
o6U8a8v5gCfscOX8i2dMvknRvug1jE/P+Tqkv/R8+ThgWNtCLxG3siF2+ZTNqbv+9wOYemwjcjiG
zPxcz8AguL/eTLmShf/JNGus6M0wxtW94u6Ghmu2q6nWfE5WSaiLugPItk4zZzqJsQN7S0sIGetG
WjJGo18ZKu58CMHHhHEnmPi8uQfPkxnjktSBM78DdbBYhnFssmhC4yaItPJlla0Cxg5TZe74cNwt
3KTfE+F3R9IQ+/hPlXMnheifTJdK5Hh/Uy4/wgvV4RvvnLerKjA9bLzSnkth+Kp0Qq/uBL+NG5uw
cKu1/f9pYm2eo5OinU0CAwEAAaMqMCgwGAYDVR0RBBEwD4ENemx5bnhAYWNtLm9yZzAMBgNVHRMB
Af8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAMGVms8JNsdEQWxf5ubEqUmtqseXSOkWOc06LQ1WWgDF
9rGw3toh+Uupx7QXiF0BszZ65p16TdmwgrTYN8OznlGlbQFlYO1gQhgbqBpJAiVocRiVAAaLlJ76
ESZC/oQJ5Yk2RX+IKJOwtUuOVVt/XPJpqyKSX+QduzAfzt9rIB2tMIIC1DCCAj2gAwIBAgIQGa/t
YFyJgyc7TOD0qZsZBTANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhh
d3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0EwHhcNMDcwNTIyMTk0NjE5WhcNMDgwNTIxMTk0NjE5WjA/MR8wHQYDVQQD
ExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMRwwGgYJKoZIhvcNAQkBFg16bHlueEBhY20ub3JnMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuLtzLVTbsqsDmUD8pWCjpTxry/mAJ+xw5fyL
Z0y+SdG+6DWMT8/5OqS/9Hz5OGBY20IvEbeyIXb5lM2pu/73A5h6bCNyOIbM/FzPwCC4v95MuZKF
/8k0a6zozTDG1b3i7oaGa7arqdZ8TlZJqIu6A8i2TjNnOomxA3tLSwgZ60ZaMkajXxkq7nwIwceE
cSeY+Ly5B8+TGeOS1IEzvwN1sFiGcWyyaELjJoi08mWVrQLGDlNl7vhw3C3cpN8T4XdH0hD7+E+V
cyeF6J9Ml0rkeH9TLj/CC9XhG++ct6sqMD1svNKeS2H4qnRCr+4Ev40bm7Bwq7X9/2libZ6jk6Kd
TQIDAQABoyowKDAYBgNVHREEETAPgQ16bHlueEBhY20ub3JnMAwGA1UdEwEB/wQCMAAwDQYJKoZI
hvcNAQEFBQADgYEAwZWazwk2x0RBbF/m5sSpSa2qx5dI6RY5zTotDVZaAMX2sbDe2iH5S6nHtBeI
XQGzNnrmnXpN2bCCtNg3w7OeUaVtAWVg7WBCGBuoGkkCJWhxGJUABouUnvoRJkL+hAnliTZFf4go
k7C1S45VW39c8mmrIpJf5B27MB/O32sgHa0wggM/MIICqKADAgECAgENMA0GCSqGSIb3DQEBBQUA
MIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRv
d24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0aW9uIFNl
cnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgQ0ExKzAp
BgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAw
WhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRp
bmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3Vpbmcg
Q0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9
zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPPK9Xz
gnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGjgZQwgZEw
EgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRoYXd0ZS5j
b20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0RBCIwIKQe
MBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM0VCD6gsu
zA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZGwDFGguC
dJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZNd4ksdMd
Rv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1
bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3Vp
bmcgQ0ECEBmv7WBciYMnO0zg9KmbGQUwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDcwNzE3MTYyNDAzWjAjBgkqhkiG9w0BCQQxFgQUU21f
K+YYiHLiPWhLr1b4f//03V8wgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNV
BAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25h
bCBGcmVlbWFpbCBJc3N1aW5nIENBAhAZr+1gXImDJztM4PSpmxkFMIGHBgsqhkiG9w0BCRACCzF4
oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4x
LDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAZr+1gXImDJztM
4PSpmxkFMA0GCSqGSIb3DQEBAQUABIIBABvUGFADzQhjZD557L3b/tGUHxE2Ipd1eOYlfHirDBhS
NWZ4/RfNxEFjUCcnV50znhmJ09GFvEIYVaMRTnmz4opx3M2sUpCfx+swTROmhbHIuEhWmVa1HkD5
yafQYCE6jR/BIGbg3dCahZRyCkQJ3nM8aWWGuoVQIvI0bq2O8wQIL+1MAPjZrX6r+fNxynK9KImo
Y59KfQyqSvZOQo9tCZhTlG9KK6Aim5VIxIMz4J4tf0DHBdsi/+iz4q+1+haVu+SY7SDN06w/GvpR
OSW5NnW7Je8z8VvJ7a8/4oDQTLtTMG409TzV3NKE0wlgkKAMLg65DAgPhyL6TzjOdoSej3kAAAAA
AAA=


--=-kYcw43ms4N2E8v4vT5g4--

