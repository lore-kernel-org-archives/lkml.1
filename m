Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0BTIqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:46:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:49452 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752786Ab0BTIqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:46:13 -0500
X-Authenticated: #2387525
X-Provags-ID: V01U2FsdGVkX19BHBsbjitBCFh9lyaRiw5hJ5rVos3JAK37bxdwMh
	Af8bo1WtIuasHh
Message-ID: <4B7FA14B.2090809@gmx.de>
Date: Sat, 20 Feb 2010 09:46:03 +0100
From: Axel Uhl <axel.uhl@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in ATA or SMART area
References: <4B72941A.7060704@gmx.de>	<4B74BDCF.1010805@kernel.org>	<4B74F263.1060709@gmx.de>	<4B7505CA.60409@kernel.org>	<4B75154B.8030507@gmx.de>	<4B7B548B.4040606@kernel.org>	<4B7C5696.7030609@gmx.de>	<19325.7006.892019.748974@pilspetsen.it.uu.se>	<4B7EDE2F.8030107@gmx.de> <19326.64703.561400.379749@pilspetsen.it.uu.se>
In-Reply-To: <19326.64703.561400.379749@pilspetsen.it.uu.se>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms000703090901020705060906"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms000703090901020705060906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mikael,

BTW, how do you know that all my PATA controllers are driven by libata? 
 From the current /var/log/dmesg:

Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:0f.1: VIA vt8237a (rev 00) IDE UDMA133
via82cxxx 0000:00:0f.1: IDE controller (0x1106:0x0571 rev 0x07)
via82cxxx 0000:00:0f.1: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xfc00-0xfc07
     ide1: BM-DMA at 0xfc08-0xfc0f
Probing IDE interface ide0...
hda: Maxtor 6L300R0, ATA DISK drive
hdb: Maxtor 6L300R0, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/133 mode selected
Probing IDE interface ide1...
hdc: SAMSUNG SP1614N, ATA DISK drive
hdd: Maxtor 6L300R0, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/100 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/133 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing 
all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=36483/255/63
hda: cache flushes supported
  hda: hda1
hdb: max request size: 512KiB
hdb: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=36483/255/63
hdb: cache flushes supported
  hdb: hdb1 hdb2
hdc: max request size: 512KiB
hdc: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hdc: cache flushes supported
  hdc: hdc1
hdd: max request size: 512KiB
hdd: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=36483/255/63
hdd: cache flushes supported
  hdd: hdd1
SCSI Media Changer driver v0.25
sata_promise 0000:00:0a.0: version 2.12
sata_promise 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
scsi0 : sata_promise
scsi1 : sata_promise
scsi2 : sata_promise
scsi3 : sata_promise
ata1: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe380 irq 18
ata2: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe280 irq 18
ata3: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe200 irq 18
ata4: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe300 irq 18
sata_via 0000:00:0f.0: version 2.4
sata_via 0000:00:0f.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
sata_via 0000:00:0f.0: routed to hard irq line 10
scsi4 : sata_via
scsi5 : sata_via
ata5: SATA max UDMA/133 cmd 0xe000 ctl 0xdc00 bmdma 0xd480 irq 21
ata6: SATA max UDMA/133 cmd 0xd880 ctl 0xd800 bmdma 0xd488 irq 21


This to me looks at least as if the VIA IDE driver still recognizes the 
IDE disks.

Best,
-- Axel

Mikael Pettersson wrote:
> Axel Uhl writes:
>  > I now enabled IO/APIC in my kernel. See attached .config. I also enabled 
>  >   pata_via but was unsure which IDE driver to disable.
> 
> That would be VIA82CXXX. But all your PATA/SATA controllers are now driven
> by libata, so you can disable IDE, i.e. set CONFIG_IDE=n.
> 
>  > The kernel 
>  > rebooted fine. The following appeared in my syslog when the smartctl 
>  > command spinned up the disk:
>  > 
>  > Feb 19 18:57:09 homemp3 kernel: ata5.00: exception Emask 0x0 SAct 0x0 
>  > SErr 0x0 action 0x6 frozen
>  > Feb 19 18:57:09 homemp3 kernel: ata5.00: failed command: SMART
>  > Feb 19 18:57:09 homemp3 kernel: ata5.00: cmd 
>  > b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
>  > Feb 19 18:57:09 homemp3 kernel:          res 
>  > 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>  > Feb 19 18:57:09 homemp3 kernel: ata5.00: status: { DRDY }
>  > Feb 19 18:57:09 homemp3 kernel: ata5: soft resetting link
>  > Feb 19 18:57:09 homemp3 kernel: ata5.00: configured for UDMA/133
>  > Feb 19 18:57:09 homemp3 kernel: ata5: EH complete
>  > 
>  > 
>  > At least it seems that the kernel recovered better from this exception 
>  > than before. In particular, IRQ10 didn't get disabled and so I/O 
>  > continued to work fine. Thanks for the hint.
>  > 
>  > Would you consider the exception above a serious problem that should be 
>  > taken care of somehow?
> 
> Apparently this disk likes to complain when issued a SMART command while spun
> down, but as libata EH recovers nicely there's no real reason to worry.
> 

-- 
Find Security Certificate at http://www.axel-uhl.de/cgi-bin/cacert.cgi

--------------ms000703090901020705060906
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIE2jCC
AmkwggHSAgkAi0l9/SdBVAAwDQYJKoZIhvcNAQEEBQAwfjELMAkGA1UEBhMCREUxCzAJBgNV
BAgTAkJXMRIwEAYDVQQHEwlSYXVlbmJlcmcxETAPBgNVBAoTCEF4ZWwgVWhsMRswGQYDVQQD
ExJBeGVsIFVobCdzIFJvb3QgQ0ExHjAcBgkqhkiG9w0BCQEWD2F4ZWwudWhsQGdteC5kZTAe
Fw0wNjA0MTgyMzA1MDFaFw0xNjA0MTUyMzA1MDFaMHQxCzAJBgNVBAYTAkRFMQswCQYDVQQI
EwJCVzESMBAGA1UEBxMJUmF1ZW5iZXJnMREwDwYDVQQKEwhBeGVsIFVobDERMA8GA1UEAxMI
QXhlbCBVaGwxHjAcBgkqhkiG9w0BCQEWD2F4ZWwudWhsQGdteC5kZTCBnzANBgkqhkiG9w0B
AQEFAAOBjQAwgYkCgYEAl9Q/pnp2Yb4HEu2vtAgOIJ02pF6vGH+DJuE/s0OCgn7Flc7R5kSk
u0xT2HmfhY9CVQ0DTijhQV+FAjQxdd7GZoutvOeqh/nY+6b3jAbr/9ffuOdSh9pVfbX4ExMv
lTTsqokhNrYYOzQgXvMET9AWGSAlNO5oXCwaMjJvS0/DLZUCAwEAATANBgkqhkiG9w0BAQQF
AAOBgQDiDXtdZMivY59fjDUQHpIMfRubhxi1rz2gJJZKTSYP+NRswpgjHgtzVwy18HSBlrdI
DRJqwZaEv1PXE7+56HOnBRBKjEWfSG3cyk99FdyEeC/uJUDhiWFYycvvH41H43iJTP2x0EDf
75Qa5HhPnX/cDId91Z+hyYR34cF6b+tozjCCAmkwggHSAgkAi0l9/SdBVAAwDQYJKoZIhvcN
AQEEBQAwfjELMAkGA1UEBhMCREUxCzAJBgNVBAgTAkJXMRIwEAYDVQQHEwlSYXVlbmJlcmcx
ETAPBgNVBAoTCEF4ZWwgVWhsMRswGQYDVQQDExJBeGVsIFVobCdzIFJvb3QgQ0ExHjAcBgkq
hkiG9w0BCQEWD2F4ZWwudWhsQGdteC5kZTAeFw0wNjA0MTgyMzA1MDFaFw0xNjA0MTUyMzA1
MDFaMHQxCzAJBgNVBAYTAkRFMQswCQYDVQQIEwJCVzESMBAGA1UEBxMJUmF1ZW5iZXJnMREw
DwYDVQQKEwhBeGVsIFVobDERMA8GA1UEAxMIQXhlbCBVaGwxHjAcBgkqhkiG9w0BCQEWD2F4
ZWwudWhsQGdteC5kZTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAl9Q/pnp2Yb4HEu2v
tAgOIJ02pF6vGH+DJuE/s0OCgn7Flc7R5kSku0xT2HmfhY9CVQ0DTijhQV+FAjQxdd7GZout
vOeqh/nY+6b3jAbr/9ffuOdSh9pVfbX4ExMvlTTsqokhNrYYOzQgXvMET9AWGSAlNO5oXCwa
MjJvS0/DLZUCAwEAATANBgkqhkiG9w0BAQQFAAOBgQDiDXtdZMivY59fjDUQHpIMfRubhxi1
rz2gJJZKTSYP+NRswpgjHgtzVwy18HSBlrdIDRJqwZaEv1PXE7+56HOnBRBKjEWfSG3cyk99
FdyEeC/uJUDhiWFYycvvH41H43iJTP2x0EDf75Qa5HhPnX/cDId91Z+hyYR34cF6b+tozjGC
AzQwggMwAgEBMIGLMH4xCzAJBgNVBAYTAkRFMQswCQYDVQQIEwJCVzESMBAGA1UEBxMJUmF1
ZW5iZXJnMREwDwYDVQQKEwhBeGVsIFVobDEbMBkGA1UEAxMSQXhlbCBVaGwncyBSb290IENB
MR4wHAYJKoZIhvcNAQkBFg9heGVsLnVobEBnbXguZGUCCQCLSX39J0FUADAJBgUrDgMCGgUA
oIIB/jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDAyMjAw
ODQ2MDNaMCMGCSqGSIb3DQEJBDEWBBQ+nS+WmQrCP1OJju+7rDF8rzbn3jBfBgkqhkiG9w0B
CQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZwGCSsGAQQBgjcQBDGBjjCBizB+
MQswCQYDVQQGEwJERTELMAkGA1UECBMCQlcxEjAQBgNVBAcTCVJhdWVuYmVyZzERMA8GA1UE
ChMIQXhlbCBVaGwxGzAZBgNVBAMTEkF4ZWwgVWhsJ3MgUm9vdCBDQTEeMBwGCSqGSIb3DQEJ
ARYPYXhlbC51aGxAZ214LmRlAgkAi0l9/SdBVAAwgZ4GCyqGSIb3DQEJEAILMYGOoIGLMH4x
CzAJBgNVBAYTAkRFMQswCQYDVQQIEwJCVzESMBAGA1UEBxMJUmF1ZW5iZXJnMREwDwYDVQQK
EwhBeGVsIFVobDEbMBkGA1UEAxMSQXhlbCBVaGwncyBSb290IENBMR4wHAYJKoZIhvcNAQkB
Fg9heGVsLnVobEBnbXguZGUCCQCLSX39J0FUADANBgkqhkiG9w0BAQEFAASBgBXdtTyMwI+v
MLvOqFhlYhYPo94dJn53il2jhbfQSOPytuAoQSNwAX91J+odwSqTPLKo46x3u0dJZwOtAomn
lLWkrDpesJGTCXu9XxAXyvzrRuH49hIozMG4uOvRpgv26KBTj/sxHXYc8aISzDObEv9cDIRK
2uLOmi2olmuBd2FSAAAAAAAA
--------------ms000703090901020705060906--
