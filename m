Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYKJXxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYKJXxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYKJXxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:53:03 -0500
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:52982 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752858AbYKJXxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:53:01 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Subject: Re: ACPI crash on lid close - SMP race?
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081110172946.GA3512@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org>
	 <1226337995.5292.25.camel@segulix.localdomain>
	 <20081110172946.GA3512@srcf.ucam.org>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-i1gTX6O5del9hXf2ZdDS"
Date: Mon, 10 Nov 2008 23:52:53 +0000
Message-Id: <1226361173.18286.12.camel@segulix.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i1gTX6O5del9hXf2ZdDS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-11-10 at 17:29 +0000, Matthew Garrett wrote:
> On Mon, Nov 10, 2008 at 05:26:35PM +0000, Sergio Monteiro Basto wrote:
> > Hi, About this _DOS , I reported this problem a long time ago, which no=
w
> > is on http://bugzilla.kernel.org/show_bug.cgi?id=3D6001
> > Could you put yours comment on it ?=20
> >=20
> > On fedora stock kernel, appears one patch, (Now I see that you are the
> > author :) )=20
> >=20
> > I tested your patch and it works for me !=20
>=20
> Yeah, that's the "safe" patch which stops us executing the codepath that=20
> breaks, but also means I don't get display switch events. Having it set=20
> to 1 means executing BIOS code that's likely to interfere with the rest=20
> of the system, so a crash isn't surprising.=20

Are you talking about 1st or 2nd parameter ?=20
I prefer=20
"return acpi_video_bus_DOS(video, 1, 0);" (which is the original code,
before last change on kernel vanilla)=20


> But a setting of 0 *should*=20
> be safe, and I'm quite confused as to why it's exploding.

The second parameter ?=20
I got some instability (after resume from disk) with a
kernel-2.6.27.4-79, which have yours patch, but I am far to be sure that
is related.=20

Thanks,=20
--=20
S=C3=A9rgio M. B.

--=-i1gTX6O5del9hXf2ZdDS
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGVjCCAw8w
ggJ4oAMCAQICEA6CVh3keQ8TFtyrh/wrbgYwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MTAxNDAzMTc0N1oXDTA5MTAxNDAzMTc0
N1owSzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEoMCYGCSqGSIb3DQEJARYZc2Vy
Z2lvQHNlcmdpb21iLm5vLWlwLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ2D
rpizYnrRUFYQm6b6ZcE50ta36mutS13FIAqg0ugCjlSFSv+nkjbfEBOug+hb5vh9SOBOLy+UFJrn
2MibIuLGip4OsawcJ41Z7prkKlUCIwtNLmb/m7swubSLqFRiojy0ctMhMWtDt9xzwOYmZN7yGMiS
jFHivrtZRGPWA7tPzN3KOQeSP4DYxLZ06a3ZOwqR4g3NkQeWbdLVvBe6r3mKtaoDeirW5XT8epyh
vqRK7izl/vOum2Gx+HeaLpyH5pTOhMd2K7DTfMiBjqBxchUDTccOykMN+5i9ketxy3Bh0PfEStZh
vjaZbCsJIV2WQc/jAH+k3xef41fci2o+Cz0CAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgSQMBEGCWCG
SAGG+EIBAQQEAwIFoDAkBgNVHREEHTAbgRlzZXJnaW9Ac2VyZ2lvbWIubm8taXAub3JnMAwGA1Ud
EwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAABP+jrmaOnO/2yM7OeJmjEVjDJpT2baLpvBL1k4O
6HSVgsx5JidSa+vF/cKaP1UFko8XT2TooDpnrTbw//Rkfd6ZbeXXqzdIJQs4xiSRGgcMuJL8GtuH
LQHkOIqKaPW+KSzVG68U/NzSzqdtr5iPwE6YCLMN0WnVduhgLQlXqkAwggM/MIICqKADAgECAgEN
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
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEA6CVh3keQ8TFtyrh/wrbgYwCQYFKw4DAhoFAKBdMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA4MTExMDIzNTI0NVowIwYJKoZI
hvcNAQkEMRYEFJRHEAyC6621RU+McAXgzdg1ixWGMA0GCSqGSIb3DQEBAQUABIIBAJeeJC2MCbUx
6bQrwHlJLMASzLmRtFWvQv50MgQUrVZXf9/pBQ0JjaxAKoQ52GOfSSGBmkM9/mL9vbnej3sD2Un3
nn51N5KgySqmFqeT3IFKEgprwVRGRBspjzDs1wtma3PmgRo7slAp8mXP/d7kNu5qcXfNlUbrX2cr
DwhXIDPuXOJHsTVvsTNqfDCXa89R0L4AtudTlBbUmOD610TIacVvOQAFX7p+5DO+eJeoPpPEE1Qc
yJnVZI6WUGXuwp9v7Hf6wlDcmPrmvbiVXpQPbmECn1Hjx3pVNRAjIg1qNko+EM86KoJ8CufY/Y85
FAdE84uHhxnnipU4eoW0ltyqUYkAAAAAAAA=


--=-i1gTX6O5del9hXf2ZdDS--

