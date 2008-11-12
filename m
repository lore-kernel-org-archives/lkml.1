Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYKLFbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYKLFbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYKLFbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:31:41 -0500
Received: from smtp2.netcabo.pt ([212.113.174.29]:58251 "EHLO
	exch01smtp12.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751026AbYKLFbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:31:39 -0500
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2008 00:31:39 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhdXAA/3GUnVFv6LPGdsb2JhbACBdpIpAQEBATQCuHmCUoEF
X-Antivirus-bastov-Mail-From: sergio@sergiomb.no-ip.org via bastov.localdomain
X-Antivirus-bastov: 1.25-st-qms (Clear:RC:0(213.22.108.228):SA:0(2.2/5.0):. Processed in 2.644586 secs Process 22472)
Subject: Re: ACPI crash on lid close - SMP race?
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
Reply-To: sergio@sergiomb.no-ip.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Zhang Rui <rui.zhang@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081111020539.GA11616@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org>
	 <1226366834.15014.60.camel@rzhang-dt>
	 <20081111013359.GA11364@srcf.ucam.org>
	 <1226368778.15014.73.camel@rzhang-dt>
	 <20081111020539.GA11616@srcf.ucam.org>
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature"; boundary="=-C36Wh8Fz5xl8PICQsbVt"
Date: Wed, 12 Nov 2008 05:21:15 +0000
Message-Id: <1226467275.3362.43.camel@monteirov>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
X-OriginalArrivalTime: 12 Nov 2008 05:21:23.0372 (UTC) FILETIME=[80C8CEC0:01C94486]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C36Wh8Fz5xl8PICQsbVt
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,=20
On my laptop which is not SMP , is a Intel Centrino 1.7Mhz , I have a
little stranger problem my lid button (backlight) doesn't work with
_DOS=3D0 after load Hal service and on first boot.=20
Like _DOS=3D0 on some laptop crash on lid close.=20

The report #6001 , made by other S=E9rgio (not me), which complains on
system freeze when _DOS=3D1 and on switching display.=20
Switching display for him means on switching to CTR or to monitor with
fn+ f4. With acpi=3Doff don't freeze because that have the event , and
with acpi on, freeze , so IMHO, this is a problem probably not related
with _DOS value, S=E9rgio Luis , in last comment
( http://bugzilla.kernel.org/show_bug.cgi?id=3D6001#c51 ) wrote with
updated kernel freeze in the 2 cases.=20

But this report introduce a patch in main kernel that change _DOS from 1
to 0 , which I think at least should be reverted.

I'd love learn more about this switches , if someone can help me with
some tip , many thanks,


On Tue, 2008-11-11 at 02:05 +0000, Matthew Garrett wrote:=20
> On Tue, Nov 11, 2008 at 09:59:38AM +0800, Zhang Rui wrote:
>=20
> > oops. sorry, I mean system crashes on lid close if _DOS=3D0 on some UP
> > platform.
>=20
> Oh, ugh. I don't have any with that issue, but that ought to be=20
> "interesting" to fix.
>=20
--=20
S=E9rgio M.B.

--=-C36Wh8Fz5xl8PICQsbVt
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
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
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA4MTExMjA1MjEwN1owIwYJKoZI
hvcNAQkEMRYEFJeJ0gByBNAX5eDAIkHxfTBNOlVwMA0GCSqGSIb3DQEBAQUABIIBAADc4uveys+B
WJHTBLDZwY870parn3igXpVMhfv7kc8io1iZEE6JL3JBmTwl9lUj5NdHWAGhxeE/53jTNmkmkMft
jwbPjpEZ+VbPEWula66fBOymDMv+Pec9Nx3l2bZnT9DT2rHQ0MoeBa1zWU9ymS3Y8JVu+CmZOoAn
xhr9HFBAFIw6ES61TMAWKnzttTLCRP2pHKe5Rsu7g5C7qVwc/V/zMvaXlyZtFxtzXiZBEvL4XfNq
1i5wSGtBeLo5+4Fbju+eVXrNFEBAKLb6JprtHHmvrvmk5gxpz2W2gw6OuBOWEGf4m5/j6yK2AzCB
E3mZfWdD++8F+w4S0si7kvgI0y8AAAAAAAA=


--=-C36Wh8Fz5xl8PICQsbVt--

