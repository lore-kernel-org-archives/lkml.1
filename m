Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXHBLuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXHBLuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXHBLu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:50:27 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:38225 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754064AbXHBLu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:50:26 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.3
Subject: Re: Section mismatch: reference to .init.text: (between 'kthreadd'
	and 'init_waitqueue_head')
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <46B1A9DE.4090907@free.fr>
References: <46B1A9DE.4090907@free.fr>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-ScOA4xyTYramSQzKcxUe"
Date: Thu, 02 Aug 2007 12:50:23 +0100
Message-Id: <1186055423.2686.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ScOA4xyTYramSQzKcxUe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 11:54 +0200, John Sigler wrote:
> Hello,
>=20
> I'm trying to build a 2.6.22.1-rt9 kernel for a P3.
>=20
> I used 'make xconfig' to create .config
> http://linux.kernel.free.fr/latency/config-2.6.22.1-rt9-adlink
>=20
> I get the following warning:
>=20
>    LD      vmlinux
>    SYSMAP  System.map
>    SYSMAP  .tmp_System.map
>    MODPOST vmlinux
> WARNING: kernel/built-in.o(.text+0x19152): Section mismatch: reference=20
> to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
>    AS      arch/i386/boot/bootsect.o
>    LD      arch/i386/boot/bootsect
>    AS      arch/i386/boot/setup.o
>    LD      arch/i386/boot/setup
>    AS      arch/i386/boot/compressed/head.o
>    CC      arch/i386/boot/compressed/misc.o
>    OBJCOPY arch/i386/boot/compressed/vmlinux.bin
>    GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
>    LD      arch/i386/boot/compressed/piggy.o
>    LD      arch/i386/boot/compressed/vmlinux
>    OBJCOPY arch/i386/boot/vmlinux.bin
>    HOSTCC  arch/i386/boot/tools/build
>    BUILD   arch/i386/boot/bzImage
> Root device is (3, 1)
> Boot sector 512 bytes.
> Setup is 7082 bytes.
> System is 1142 kB
> Kernel: arch/i386/boot/bzImage is ready  (#1)
>    Building modules, stage 2.
>    MODPOST 0 modules
>=20
>=20
> I also get the following warnings (which seem less severe)
>=20
>    CC      drivers/pci/pci.o
>    CC      drivers/pci/quirks.o
>    CC      drivers/pci/pci-driver.o
>    CC      drivers/pci/search.o
> drivers/pci/search.c: In function `pci_find_slot':
> drivers/pci/search.c:99: warning: `pci_find_device' is deprecated=20
> (declared at include/linux/pci.h:477)
> drivers/pci/search.c: At top level:
> drivers/pci/search.c:434: warning: `pci_find_device' is deprecated=20
> (declared at drivers/pci/search.c:241)
> drivers/pci/search.c:434: warning: `pci_find_device' is deprecated=20
> (declared at drivers/pci/search.c:241)
>    CC      drivers/pci/pci-sysfs.o
>    CC      drivers/pci/rom.o
>=20
>=20
> Finally, I note that X86_CMPXCHG64 is no longer defined since its=20
> specification was changed between 2.6.20 and 2.6.22.
>=20
>   config X86_CMPXCHG64
>      bool
> -   depends on !M386 && !M486
> +   depends on X86_PAE
>      default y

this patch resolve the warning ?=20
I always got this warning but don't care much about it=20

--=20
S=C3=A9rgio M. B.

--=-ScOA4xyTYramSQzKcxUe
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
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDgwMjExNTAxOFowIwYJKoZI
hvcNAQkEMRYEFH2HXHaD364dWkVGBphwQprXULOeMA0GCSqGSIb3DQEBAQUABIIBALhtxjgLAmLX
FDOENd3Rt52dL7B+5YzvHRDmwLvbNrVFBOOk/W1ICRRHj4aQN4UlB5CJVljQUX81bbLzpR96rtfX
vDcpxdwmPPKL1xbMzvQoDBl6SS9PJBZ2Smu0TYn0jbOwL+7juMfqflZODlYKkh3xTVhGH1+iCr+l
BOdvAjDOLe4+6YE6ZzNchgMN2k1MOVUvsXcBBKEyeT3BvP+a2igrf6tYBxmP6yBBo4Gl7sWUGa6g
p7dnLUeyPR+1oPLAYRctogvZGht8E6Y/7CFAEM1cwj5XtJBAQC6Qz0TRKd3Rhr7KIDMCql2ZQ9oH
s3PTu2PCHT9uA8AZWOfCkJvTNMIAAAAAAAA=


--=-ScOA4xyTYramSQzKcxUe--

