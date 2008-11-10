Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYKJR1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYKJR1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYKJR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:26:53 -0500
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:48432 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753729AbYKJR0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:26:52 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Subject: Re: ACPI crash on lid close - SMP race?
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081110161105.GA2041@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-Nr3GVYMYPyGeqhsjchiU"
Date: Mon, 10 Nov 2008 17:26:35 +0000
Message-Id: <1226337995.5292.25.camel@segulix.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Nr3GVYMYPyGeqhsjchiU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi, About this _DOS , I reported this problem a long time ago, which now
is on http://bugzilla.kernel.org/show_bug.cgi?id=3D6001
Could you put yours comment on it ?=20

On fedora stock kernel, appears one patch, (Now I see that you are the
author :) )=20

I tested your patch and it works for me !=20

linux-2.6-acpi-video-dos.patch
Disable ACPI video display switching by default

-- mjg59

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index bac2901..93b1a9e 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1818,7 +1818,7 @@ static int acpi_video_bus_put_devices(struct acpi_vid=
eo_bus *video)

 static int acpi_video_bus_start_devices(struct acpi_video_bus *video)
 {
-       return acpi_video_bus_DOS(video, 0, 0);
+       return acpi_video_bus_DOS(video, 3, 1);
 }

 static int acpi_video_bus_stop_devices(struct acpi_video_bus *video)


On Mon, 2008-11-10 at 16:11 +0000, Matthew Garrett wrote:
> If the _DOS flag on my HP 2510p is set to 0 (ie, signal OS when screen=20
> notification is requested, don't change automatically) then it'll crash=20
> on random lid open/closes. The trace generally makes little sense and=20
> depends on the kernel version and phase of the moon. I'd ignored this as=20
> firmware brokenness up until lately, but since having _DOS set to 0 is=20
> the only way to get a notification when the display switch key is=20
> pressed on this machine I'd be interested in fixing it properly.=20
>=20
> Unfortunately, I've got no real idea what on earth is going on. The only=20
> clue I've found so far is that booting with maxcpus=3D1 leaves it working=
=20
> perfectly. What parts of the ACPI stack could be triggering this?
>=20
--=20
S=C3=A9rgio M. B.

--=-Nr3GVYMYPyGeqhsjchiU
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
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA4MTExMDE3MjYzMVowIwYJKoZI
hvcNAQkEMRYEFPsbx/61ugTF3aBNGPDNBFRuz3fYMA0GCSqGSIb3DQEBAQUABIIBAB0BNu3yIqJk
0dqACNgGsrDBr1OWSnUcLp2HNeadkdb47KPw87RVQ0txkX1Y3IxswhN+ayeiVmzmPI7qUQOa5vM/
abcZAhjSJ8LQLrPupmOGyhHkX/zbOXSjZLzVlLXAFO56In2ZO1SuCmcNI6LCwibVU+kGbmqIhcsq
NbGi6VL8gcmA7sAwR2WhVKsWPNiAWHHIT57PADuP+M9RhT8TWdKY0F4BiHSDnJg/oWNuWZsIjkqc
QVaLu9t7kcDFayHOXEFx57V75g/5mpJTUdFKGein8EOGWMMrB+ix0azd5Dz4e2spaA78Ytj+NWf/
G9NhtczJkGdM0Tg4wiMblvrTO2IAAAAAAAA=


--=-Nr3GVYMYPyGeqhsjchiU--

