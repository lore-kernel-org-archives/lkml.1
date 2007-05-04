Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXEDIRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXEDIRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965744AbXEDIRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:17:04 -0400
Received: from cluster-j.mailcontrol.com ([86.111.223.190]:39688 "EHLO
	cluster-j.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965743AbXEDIQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:16:59 -0400
Message-ID: <463AEBFA.9030108@uk.neceur.com>
Date: Fri, 04 May 2007 09:16:58 +0100
From: Ross Alexander <ross.alexander@uk.neceur.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: Kernel oops with 2.6.21 while using cdda2wav & cooked_ioctl (x64-64)
 [untainted]
References: <4631AE19.7040705@uk.neceur.com> <4632C388.709@ums.usu.ru> <4635F462.30202@uk.neceur.com> <46360DC0.2010404@ums.usu.ru>
In-Reply-To: <46360DC0.2010404@ums.usu.ru>
X-MIMETrack: Itemize by SMTP Server on LDN-ARES/E/NEC(Release 6.5.5FP2|October 23, 2006) at
 04/05/2007 09:16:27,
	Serialize by Router on LDN-ARES/E/NEC(Release 6.5.5FP2|October 23, 2006) at
 04/05/2007 09:16:29,
	Serialize complete at 04/05/2007 09:16:29,
	Itemize by SMTP Server on LDN-HADES/E/NEC(Release 6.5.3|September 14, 2004) at
 04/05/2007 09:19:27,
	Serialize by Router on LDN-HADES/E/NEC(Release 6.5.3|September 14, 2004) at
 04/05/2007 09:19:29,
	Serialize complete at 04/05/2007 09:19:29
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms050200030900060404050005"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050200030900060404050005
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Alexander,

Rather than try to hunt down the oops via the interrupt code I'll try to 
fix the original problem, which is cooked_ioctl incorrectly determines 
the length of the track when an audio CD also contains a data track.  I 
have noticed this bug for a long time (over a year) but only recently 
has it been causing the kernel to crash.  I know this is avoidable by 
using cdda2wav in raw mode but it would be good to fix.

If anybody has any pointers about how I should go about this it would be 
most appriciated.

Many thanks,

Ross

Ross Alexander
Phone: +44 20 8752 3394
SAP Basis, Technical Support Services, Corporate IT Centre, NEC Europe 
Limited

------------------------------------------------------------------------
|The contents of this email are intended for the use of the 
individual(s) or entity named above and may contain information that is 
privileged and/or confidential. If you are not the intended recipient, 
you are not authorised to make any use of it. In such case, please 
notify the sender and immediately delete the message from your system. 
The message content may contain personal views which are not the views 
of the company unless specifically stated. All liability for loss or 
damage caused by viruses is excluded. |

| NEC Europe Limited | Registered Office: NEC House, 1 Victoria Road, 
London W3 6BL | Registered in England 2832014 |


--------------ms050200030900060404050005
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJ6zCC
AzkwggKioAMCAQICEEPeRQZ+ke07tnDkF1JmSbUwDQYJKoZIhvcNAQEFBQAwgcExCzAJBgNV
BAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjE8MDoGA1UECxMzQ2xhc3MgMiBQdWJs
aWMgUHJpbWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEcyMTowOAYDVQQLEzEoYykg
MTk5OCBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMB4XDTk4MDUxOTAwMDAwMFoXDTA5MTAxMjIzNTk1
OVowQzERMA8GA1UEChMIVmVyaVNpZ24xLjAsBgNVBAsTJVZlcmlTaWduIENsYXNzIDIgT25T
aXRlIEluZGl2aWR1YWwgQ0EwgZ0wDQYJKoZIhvcNAQEBBQADgYsAMIGHAoGBANwqmZ1uM/y7
QXbEOR6N93bnkA90VWFhcjz4N0sbHwjpMB1wxRaJYDNGSH/G0Jo9dpjDocGsUtEXuRQEaYZc
YU+zZWWLY6LuIXxBr61yQMNNkbNJvpj7V8daLrBLp+8JJPOBnTjFktpKp5hRqdgwdi1q1q8v
ftsRKoX7ZWBaRegbAgEDo4GwMIGtMA8GA1UdEwQIMAYBAf8CAQAwRAYDVR0gBD0wOzA5Bgtg
hkgBhvhFAQcXAjAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBh
MDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwudmVyaXNpZ24uY29tL3BjYTItZzIuY3Js
MAsGA1UdDwQEAwIBBjARBglghkgBhvhCAQEEBAMCAQYwDQYJKoZIhvcNAQEFBQADgYEAiZC+
rnOV3EIeTaCP7wL7qWhbC+0sRbOI645OzzSKpjUOg4zQtBMv66qV/DZ+aIWc/DdZU8q5DAaE
4TtkBwshNER1iDc2xbVYDag4O6+gYbh8bBef4f/h2kOoQoYCXUrtnJCNEqpMwm4DmB9Dr36b
SbW0dKNurWpb6y+xy5oeppowggNTMIICvKADAgECAhB5l1qUc4EbBTugxCQ43zrWMA0GCSqG
SIb3DQEBBAUAMEMxETAPBgNVBAoTCFZlcmlTaWduMS4wLAYDVQQLEyVWZXJpU2lnbiBDbGFz
cyAyIE9uU2l0ZSBJbmRpdmlkdWFsIENBMB4XDTA2MTAxMDAwMDAwMFoXDTA3MTAxMDIzNTk1
OVowgcoxGzAZBgNVBAoMEk5FQyBFdXJvcGUgTGltaXRlZDFGMEQGA1UECww9d3d3LnZlcmlz
aWduLmNvbS9yZXBvc2l0b3J5L0NQUyBJbmNvcnAuIGJ5IFJlZi4sTElBQi5MVEQoYyk5OTEd
MBsGA1UECwwUQ29tcGFueSAtIE5FQyBFdXJvcGUxFzAVBgNVBAMMDlJvc3MgQWxleGFuZGVy
MSswKQYJKoZIhvcNAQkBFhxyb3NzLmFsZXhhbmRlckB1ay5uZWNldXIuY29tMIGfMA0GCSqG
SIb3DQEBAQUAA4GNADCBiQKBgQDCRNFQCkM8QFajM2aa0WCpH/p4+PTvvN4FbWF1MoPOsTwV
9w4asRK4mijS+bAiHf59ytfdyOeagetcE8JWSpfigmoFrQANaUtJJJ3PPvKgZ/BcX3lI5vDJ
L2hqcb5dTuhhHPQkdm5gaRAlUzydMgyrVabOgspU+rnMTjG2m3Jb1QIDAQABo4G/MIG8MAkG
A1UdEwQCMAAwRAYDVR0gBD0wOzA5BgtghkgBhvhFAQcXAjAqMCgGCCsGAQUFBwIBFhxodHRw
czovL3d3dy52ZXJpc2lnbi5jb20vcnBhMAsGA1UdDwQEAwIFoDARBglghkgBhvhCAQEEBAMC
B4AwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL29uc2l0ZWNybC52ZXJpc2lnbi5jb20vT25T
aXRlUHVibGljL0xhdGVzdENSTC5jcmwwDQYJKoZIhvcNAQEEBQADgYEALaHd0/8VrRq/Ei2z
SDeXwckE990379HQ96z6aYYAes9dQrrcgakFVj2OyxxBTyp02aFAqHbD57mgX38vA1Qveknk
MyHpeRLdpMq7gIp6PwxSldlikwuIp516k4FQ9eD7FkDjxc+bcjuMwnMhSoiP6fxK8W5a6Cz8
58H2MHxq3uIwggNTMIICvKADAgECAhB5l1qUc4EbBTugxCQ43zrWMA0GCSqGSIb3DQEBBAUA
MEMxETAPBgNVBAoTCFZlcmlTaWduMS4wLAYDVQQLEyVWZXJpU2lnbiBDbGFzcyAyIE9uU2l0
ZSBJbmRpdmlkdWFsIENBMB4XDTA2MTAxMDAwMDAwMFoXDTA3MTAxMDIzNTk1OVowgcoxGzAZ
BgNVBAoMEk5FQyBFdXJvcGUgTGltaXRlZDFGMEQGA1UECww9d3d3LnZlcmlzaWduLmNvbS9y
ZXBvc2l0b3J5L0NQUyBJbmNvcnAuIGJ5IFJlZi4sTElBQi5MVEQoYyk5OTEdMBsGA1UECwwU
Q29tcGFueSAtIE5FQyBFdXJvcGUxFzAVBgNVBAMMDlJvc3MgQWxleGFuZGVyMSswKQYJKoZI
hvcNAQkBFhxyb3NzLmFsZXhhbmRlckB1ay5uZWNldXIuY29tMIGfMA0GCSqGSIb3DQEBAQUA
A4GNADCBiQKBgQDCRNFQCkM8QFajM2aa0WCpH/p4+PTvvN4FbWF1MoPOsTwV9w4asRK4mijS
+bAiHf59ytfdyOeagetcE8JWSpfigmoFrQANaUtJJJ3PPvKgZ/BcX3lI5vDJL2hqcb5dTuhh
HPQkdm5gaRAlUzydMgyrVabOgspU+rnMTjG2m3Jb1QIDAQABo4G/MIG8MAkGA1UdEwQCMAAw
RAYDVR0gBD0wOzA5BgtghkgBhvhFAQcXAjAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy52
ZXJpc2lnbi5jb20vcnBhMAsGA1UdDwQEAwIFoDARBglghkgBhvhCAQEEBAMCB4AwSQYDVR0f
BEIwQDA+oDygOoY4aHR0cDovL29uc2l0ZWNybC52ZXJpc2lnbi5jb20vT25TaXRlUHVibGlj
L0xhdGVzdENSTC5jcmwwDQYJKoZIhvcNAQEEBQADgYEALaHd0/8VrRq/Ei2zSDeXwckE9903
79HQ96z6aYYAes9dQrrcgakFVj2OyxxBTyp02aFAqHbD57mgX38vA1QveknkMyHpeRLdpMq7
gIp6PwxSldlikwuIp516k4FQ9eD7FkDjxc+bcjuMwnMhSoiP6fxK8W5a6Cz858H2MHxq3uIx
ggKEMIICgAIBATBXMEMxETAPBgNVBAoTCFZlcmlTaWduMS4wLAYDVQQLEyVWZXJpU2lnbiBD
bGFzcyAyIE9uU2l0ZSBJbmRpdmlkdWFsIENBAhB5l1qUc4EbBTugxCQ43zrWMAkGBSsOAwIa
BQCgggGDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDUw
NDA4MTY1OFowIwYJKoZIhvcNAQkEMRYEFH4OacEqaM9Ppv2EGqc1KE44IGZeMFIGCSqGSIb3
DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMGYGCSsGAQQBgjcQBDFZMFcwQzERMA8GA1UEChMIVmVy
aVNpZ24xLjAsBgNVBAsTJVZlcmlTaWduIENsYXNzIDIgT25TaXRlIEluZGl2aWR1YWwgQ0EC
EHmXWpRzgRsFO6DEJDjfOtYwaAYLKoZIhvcNAQkQAgsxWaBXMEMxETAPBgNVBAoTCFZlcmlT
aWduMS4wLAYDVQQLEyVWZXJpU2lnbiBDbGFzcyAyIE9uU2l0ZSBJbmRpdmlkdWFsIENBAhB5
l1qUc4EbBTugxCQ43zrWMA0GCSqGSIb3DQEBAQUABIGAHUeu7+x0Qok4FpvqETZ7S7Jo2GWl
bF3+Gz7dSEqaZ21v7VqapLUtghOaowIRiBs0AGzc5JQQfzCPZmCvRWjqM1BGm9t7fpFQBIEH
gBnbakEHD0m7m1Z8jEUGZOpTBHZHuG6CzU/vhg8N1/ICq0Vjs090lbyyfAJpxuua0KbZ29IA
AAAAAAA=
--------------ms050200030900060404050005--
