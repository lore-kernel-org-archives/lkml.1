Return-Path: <linux-kernel-owner+w=401wt.eu-S1423304AbXD3Oj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423304AbXD3Oj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423320AbXD3Oj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:39:56 -0400
Received: from cluster-j.mailcontrol.com ([86.111.223.190]:51481 "EHLO
	cluster-j.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423304AbXD3Ojx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:39:53 -0400
X-Greylist: delayed 2837 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 10:39:53 EDT
Message-ID: <4635F462.30202@uk.neceur.com>
Date: Mon, 30 Apr 2007 14:51:30 +0100
From: Ross Alexander <ross.alexander@uk.neceur.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: Kernel oops with 2.6.21 while using cdda2wav & cooked_ioctl (x64-64)
 [untainted]
References: <4631AE19.7040705@uk.neceur.com> <4632C388.709@ums.usu.ru>
In-Reply-To: <4632C388.709@ums.usu.ru>
X-MIMETrack: Itemize by SMTP Server on LDN-ARES/E/NEC(Release 6.5.5FP2|October 23, 2006) at
 30/04/2007 14:51:14,
	Serialize by Router on LDN-ARES/E/NEC(Release 6.5.5FP2|October 23, 2006) at
 30/04/2007 14:51:16,
	Serialize complete at 30/04/2007 14:51:16,
	Itemize by SMTP Server on LDN-FATES/E/NEC(Release 6.5.5|November 30, 2005) at
 30/04/2007 14:54:34,
	Serialize by Router on LDN-FATES/E/NEC(Release 6.5.5|November 30, 2005) at
 30/04/2007 14:54:48,
	Serialize complete at 30/04/2007 14:54:48
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms010000000103080003040805"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010000000103080003040805
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have repeated the cdda2wav run without the nvidia module and I get a 
very similar kernel oops.  I have to hand copy the oops so it could well 
contain errors.  If somebody can tell me exactly what information they 
require it would be helpful.    I have run this a number of times and 
the call trace isn't identical.  Lastest says "kernel BUG at 
kernel/timer.c:551! invalid opcode: 0000 [1] PREMPT KERNEL".  I can run 
this again if necessary.

Cheers,

Ross

Unable gto handle kernel NULL pointer dereferenced at 0000000000000000 
RIP: [<0000000000000000>] stext+0x7fdff0e0/0xe0
PGD 11b356067 PUD 11aace067 PMD 0
Oops: 0010 [1] PREEMPT SMP
CPU 0
Modules linked in: ipv6 ehci_hcd ohci_hcd usbcore ohci1394 snd_hda_intel 
snd_hda_codec snd_pcm snd_timer snd soundcore 8250_pnp 8250 serial_core 
ieee1394 forcedeth snd_page_alloc
Pid: 0, comm: swapper Not tainted 2.6.21 #1
RIP: 0010:[<0000000000000000>] [<0000000000000000>] stext+0x7fdff0e0/0xe0
RSP: 0018:ffffffff805dcec8 EFLAGS: 00010246
RAX: ffffffff80587fd8 RBX: 000000000000 RCS: ffff81011a5fd370
RDX: ffffffff805dced0 RSI: 1058e226d118dc67 RDI: 0000000000000000
RBP: ffffffff805f8d80 R08: 0000000000000002 R09: 0000000001365df8
R10:0000000001365df8 R11: 0000000001365df8 R12: 0000000000000102
R13: 0000000000000000(0000) GS:ffffffff8054f000(0000) knlGS:00000000f7e248d0
GS: 0010 GS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000 CR3: 000000011a4df000 CR4: 0000000000006e0
Process swapper (pid: 0, threadinfo ffffff80586000, task ffffffff8050e140)

Call Trace:
run_timer_softirq+0x156/0x1ac
__do_softirq+0x50/0xbb
call_softirq+0x1c/02x8
do_softieq+0x2f/x097
irq_exit+0x3d/0x4f
smp_apic_timer_interrupt+0x46/0x58
default_idle+0x0/0x3d
apic_timer_interrupt+0x66/0x70
<EOI> default_idle+0x29/0x3d
cpu_idle+0x8b/0xcc
start_kernel+0x266/0x26f
_sinittext+0x175/0x179




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


--------------ms010000000103080003040805
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
BQCgggGDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDQz
MDEzNTEzMFowIwYJKoZIhvcNAQkEMRYEFLvMwDC8C1zwkqdKIb4PMmqL5xlaMFIGCSqGSIb3
DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMGYGCSsGAQQBgjcQBDFZMFcwQzERMA8GA1UEChMIVmVy
aVNpZ24xLjAsBgNVBAsTJVZlcmlTaWduIENsYXNzIDIgT25TaXRlIEluZGl2aWR1YWwgQ0EC
EHmXWpRzgRsFO6DEJDjfOtYwaAYLKoZIhvcNAQkQAgsxWaBXMEMxETAPBgNVBAoTCFZlcmlT
aWduMS4wLAYDVQQLEyVWZXJpU2lnbiBDbGFzcyAyIE9uU2l0ZSBJbmRpdmlkdWFsIENBAhB5
l1qUc4EbBTugxCQ43zrWMA0GCSqGSIb3DQEBAQUABIGAdaWr4cFPY+elYI64gR5ckFyGwc3P
BFRMbXxJb+8lkBopzUZpp4Y+3GexoXfwmaVAxajgLvKbZ/5JhPFNDMqqbJWkf3w7Jc1iwfSe
1aw978UXEaplPvxuwhkZjTrFguh9GMbdtVCkPn9ZAR4kuAkq+PfUCxRQ2qfBB5xC76qUCuAA
AAAAAAA=
--------------ms010000000103080003040805--
