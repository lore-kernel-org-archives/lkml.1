Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXCKEce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXCKEce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbXCKEcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:32:33 -0500
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:34722 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933079AbXCKEca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:32:30 -0500
X-AntiVirus: PTMail-AV 0.3-0.90.0
Subject: Re: and try remove another quirk on this computers Re: [3/6]
	2.6.21-rc2: known regressions
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu =?ISO-8859-1?Q?B=E9rard?= <Mathieu.Berard@crans.org>,
       Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703092134330.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org>
	 <45F20541.9090208@crans.org>
	 <1173499896.21891.34.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703092134330.10832@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-eI40XrYQEOkMDQcihixK"
Date: Sun, 11 Mar 2007 04:32:55 +0000
Message-Id: <1173587575.11759.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eI40XrYQEOkMDQcihixK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-09 at 21:41 -0800, Linus Torvalds wrote:
>=20
> On Sat, 10 Mar 2007, Sergio Monteiro Basto wrote:
> >=20
> > With this quirk I got this oops on hibernate (but computer still
> > working)=20
>=20
> Well, strictly speaking it's a warning, not an oops per se.=20
>=20
> What happens is that the quirk wants to do an "ioremap_nocache()", which=20
> allocates memory, and that happens very early during initialization when=20
> interrupts are disabled.
>=20
> And you're really not supposed to allocate memory, except using=20
> GFP_ATOMIC. But we've always been lax about that during early boot, so we=
=20
> have stuff that does. And resume ends up doing a lot of the same things=20
> early boot does, and shows issues like this.
>=20
> So the quirk is probably still a good idea, and the warning message is=20
> just that - a very scary warning message, but not an indicator that=20
> anything is seriously screwed up for you.
>=20
> (It is an indication of a real bug, though, even though it's harmless in=20
> practice in this case)

Hi, thanks=20
Just to write, I test last fedora kernel(2.6.20-1.2981.fc7) which is
based on 2.6.21-rc3-git5, without any problem, less than the scary
warning, talked in this email :)

Best regards,
--=20
S=C3=A9rgio M. B.

--=-eI40XrYQEOkMDQcihixK
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGVjCCAw8w
ggJ4oAMCAQICEGne8YrzxxgYAeyxZxmiO+owDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MTAxMTEwMjAzOVoXDTA3MTAxMTEwMjAz
OVowSzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEoMCYGCSqGSIb3DQEJARYZc2Vy
Z2lvQHNlcmdpb21iLm5vLWlwLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN9R
ix9koyWSNQDmAHxcSeWXdFO1osqg2yeNgBBl+fz8FLYyROsDGpZMcnOd/Df6tWwMZpMSYDNIksiZ
5VkCWaWIzIBccHX3wIkqrkcq3v1OcPGW9adXClXSbSZ0Hb4V4+bQ9LMAOjaMlH/dKLVkln6qmbko
NOxgPotdVxCGcUy1Pqa4dT1zFo5+nIv1NAUNqKpq63X/+3nILNG4JGAvLIL8wcYs0cETGS6vISgd
YFN/JlIqekWUGGUmc+SJcyyTWjXGN+2G0SDS8K3a9NFCo7a1Y0FyHQxikQRtB9sCcpQCoXiqaWsT
npSrNJ0Od4w1sHZz09uEdhWKqXEmJsKKwi8CAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgSQMBEGCWCG
SAGG+EIBAQQEAwIFoDAkBgNVHREEHTAbgRlzZXJnaW9Ac2VyZ2lvbWIubm8taXAub3JnMAwGA1Ud
EwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAwVE8/kY82qYG7I2+gW0NhSyn+DR0uAWYbSxB2NgP
16QOrzXt2HazlXkl2Bc+NKQEqEGKOu5fPPg2GoJ3zDO1Y8GUNGtJH0sX+63RGoUNOAv+bAK1Nxhb
illDUUCjW3OqA/hRyBwjU9kHJPYhl1EbAUGpAhfENHjkS/S7b1REBLMwggM/MIICqKADAgECAgEN
MA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIw
EAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9D
ZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwg
RnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20w
HhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZy
ZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZ
Wh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuv
PAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBly
YLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRw
Oi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMC
AQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEB
BQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFh
YsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVN
d+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIB/DCCAfgCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UE
ChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEGne8YrzxxgYAeyxZxmiO+owCQYFKw4DAhoFAKBdMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDMxMTA0MzI0OVowIwYJKoZI
hvcNAQkEMRYEFKJQ2BgB6gHc+s4orpsiDpk2ZDIsMA0GCSqGSIb3DQEBAQUABIIBACUNQgue/sIb
NvCY/lgu8VZMfHVJiDDVmoxSmd3JN/18MPv4HIoSq15KxI/m3ixYXy35+ym6H5xeQxUAV094Dmvz
FySDyoIl6vzoZvW8gV0+hzfMxRB7rkl+nZRWmsg3yIjYpN+SE+2fRbQAt8c4ApiIM0TbIm818/F6
a0AoZru6Os/2cj2Bg0skzMlobtecLezeV0tMOzRqaJqXq2EQsUFsE/NGw2Xzkp9pYUY89hCBPTcL
spIWx7W6tfAB9A/jn1NkCpQ9FI0tfHdE0n0cWYMi7diCDmM4wyk/b9bJTG+2+pajLUi0m4h6KZP/
frPK3KdtuNetGKzpn2xt0/RDTWoAAAAAAAA=


--=-eI40XrYQEOkMDQcihixK--

