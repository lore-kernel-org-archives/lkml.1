Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbXG1Ou5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbXG1Ou5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 10:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXG1Ouu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 10:50:50 -0400
Received: from relay1.ptmail.sapo.pt ([212.55.154.21]:58624 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750709AbXG1Out (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 10:50:49 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 10:50:48 EDT
X-AntiVirus: PTMail-AV 0.3-0.90.3
Subject: Re: [2.6 patch] let SUSPEND select HOTPLUG_CPU
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <46AA7609.1040900@s5r6.in-berlin.de>
References: <200707251238.50218.lenb@kernel.org>
	 <200707262117.26353.rjw@sisk.pl>
	 <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org>
	 <200707262248.09187.rjw@sisk.pl>
	 <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
	 <20070727222503.GB15129@stusta.de>  <46AA7609.1040900@s5r6.in-berlin.de>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-5G9Hj1OWjw6c2vV+LLoe"
Date: Sat, 28 Jul 2007 15:44:30 +0100
Message-Id: <1185633870.2718.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5G9Hj1OWjw6c2vV+LLoe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-07-28 at 00:47 +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> > The dependency of SUSPEND_SMP on HOTPLUG_CPU is quite unintuitive,
>=20
> It's not entirely unintuitive.  That option's full name is "Support for
> suspend on SMP and hot-pluggable CPUs".
>=20

I have to give reason to Len Brown on limit the options else this is
much more difficult.

Make sense define SUSPEND_SMP without define HOTPLUG_CPU ?
or make sense define HOTPLUG_CPU without define SUSPEND_SMP ?
Even if both options could make sense, we have to have the code prepare
for it, which couldn't be prepared.
But it is more easier and more importante focus on major cases which is:
"I don't care" and force some configuration and everybody test the same
code. Else in ACPI we have many issues to resolve like with this define
and without other, which philosophically could be interesting but is not
the major case and don't let us focus on stability.   =20

Thanks,
--=20
S=C3=A9rgio M. B.

--=-5G9Hj1OWjw6c2vV+LLoe
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
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDcyODE0NDM1M1owIwYJKoZI
hvcNAQkEMRYEFHk3N6vWVxNEBC8fD8fpQciDiUsvMA0GCSqGSIb3DQEBAQUABIIBAMbGYrDPA/q0
Lu5J2WkDt75IeFXo27fn0GgZawfs8i+J/nVefnyfKuXxsZP74XOoggbct3wPpoNnm7A4W3V3k470
P4hXKVSO4zkF9Koj9jiatzqG5IMxrtrv9h2/rdKUq1gJpBb9zrRPDOYuL873+ovCafasyOuXuPQF
zdU16roqpsat3G2ZGCih5nR3zX4ZfnFe6THaf/t2D2EqlZ6XIsfPQ0OhjxYNt5X62CBDWmDOfycI
OUM+G880oyhxRC3SOFQ0abv4Dae59dg496gBWOZg5o9oawgcGFQYfPN/VYmKauHZU8uz2fKNwCl/
UZBtCgIdg/pp3hRHnRgG+yT6tEIAAAAAAAA=


--=-5G9Hj1OWjw6c2vV+LLoe--

