Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYESJFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYESJFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYESJFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:05:06 -0400
Received: from cardassian3.kabelfoon.nl ([62.45.45.105]:62563 "EHLO
	cardassian.kabelfoon.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751439AbYESJFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:05:03 -0400
X-Greylist: delayed 1736 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 05:05:02 EDT
Message-ID: <48313BF3.3080605@caiway.nl>
Date: Mon, 19 May 2008 10:36:03 +0200
From: Jan Evert van Grootheest <j.e.van.grootheest@caiway.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: SATA disk dies and revives after boot
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms040602080208020500080009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040602080208020500080009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Yesterday the below happened on my home xen server, dom0 is debian 
stable with ubuntu kernel 2.6.24-16-xen. Given that yesterday was 
sunday, there was not much going on (I guess that we were somewhere 
between church and home, so there really was not much going on).
After this, the disk does not respond to anything and needs a reboot to 
return to sanity. After that it may work for some period of time (days 
or weeks).
I recently ran a long smart test and that returned no errors. Also after 
a reboot the disk seems to be just fine (except I need to re-add to the 
RAID1 arrays). I've also had this disk connected to a promise 
controller. The same thing happened there.
Previously, using 2.6.18, it would do this as well.

May 18 13:06:15 quark kernel: [174871.044304] ata5.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
May 18 13:06:15 quark kernel: [174871.044353] ata5.00: cmd 
e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
May 18 13:06:15 quark kernel: [174871.044355]          res 
40/00:00:01:01:80/00:00:00:00:00/00 Emask 0x4 (timeout)
May 18 13:06:15 quark kernel: [174871.044412] ata5.00: status: { DRDY }
May 18 13:06:20 quark kernel: [174876.082713] ata5: port is slow to 
respond, please be patient (Status 0xd0)
May 18 13:06:25 quark kernel: [174881.065279] ata5: soft resetting link
May 18 13:06:55 quark kernel: [174911.291301] ata5.00: qc timeout (cmd 0xec)
May 18 13:06:55 quark kernel: [174911.291337] ata5.00: failed to 
IDENTIFY (I/O error, err_mask=0x4)
May 18 13:06:55 quark kernel: [174911.291361] ata5.00: revalidation 
failed (errno=-5)
May 18 13:06:55 quark kernel: [174911.291384] ata5: failed to recover 
some devices, retrying in 5 secs
May 18 13:07:05 quark kernel: [174921.328542] ata5: port is slow to 
respond, please be patient (Status 0xd0)
May 18 13:07:10 quark kernel: [174926.312085] ata5: soft resetting link
May 18 13:07:40 quark kernel: [174956.537601] ata5.00: qc timeout (cmd 0xec)
May 18 13:07:40 quark kernel: [174956.537638] ata5.00: failed to 
IDENTIFY (I/O error, err_mask=0x4)
May 18 13:07:40 quark kernel: [174956.537662] ata5.00: revalidation 
failed (errno=-5)
May 18 13:07:40 quark kernel: [174956.537685] ata5: failed to recover 
some devices, retrying in 5 secs
May 18 13:07:50 quark kernel: [174966.580807] ata5: port is slow to 
respond, please be patient (Status 0xd0)
May 18 13:07:55 quark kernel: [174971.564289] ata5: soft resetting link
May 18 13:08:26 quark kernel: [175001.790832] ata5.00: qc timeout (cmd 0xec)
May 18 13:08:26 quark kernel: [175001.790867] ata5.00: failed to 
IDENTIFY (I/O error, err_mask=0x4)
May 18 13:08:26 quark kernel: [175001.790891] ata5.00: revalidation 
failed (errno=-5)
May 18 13:08:26 quark kernel: [175001.790914] ata5.00: disabled
May 18 13:08:31 quark kernel: [175007.327614] ata5: port is slow to 
respond, please be patient (Status 0xd0)
May 18 13:08:36 quark kernel: [175012.311144] ata5: soft resetting link
May 18 13:08:36 quark kernel: [175012.478592] ata5: EH complete
May 18 13:08:36 quark kernel: [175012.478684] sd 4:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 18 13:08:36 quark kernel: [175012.478726] end_request: I/O error, 
dev sdb, sector 62412332
May 18 13:08:36 quark kernel: [175012.478751] md: super_written gets 
error=-5, uptodate=0
May 18 13:08:36 quark kernel: [175012.478777] raid1: Disk failure on 
sdb5, disabling device.

The ata/disk info from dmesg:
[    4.716187] sata_via 0000:00:0f.0: version 2.3
[    4.716429] sata_via 0000:00:0f.0: routed to hard irq line 10
[    4.720203] scsi3 : sata_via
[    4.721459] scsi4 : sata_via
[    4.721675] ata5: SATA max UDMA/133 cmd 0xd400 ctl 0xd000 bmdma 
0xcc08 irq 20
[    5.135540] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.299951] ata5.00: ATA-7: Maxtor 6Y080M0, YAR511W0, max UDMA/133
[    5.300033] ata5.00: 160086528 sectors, multi 16: LBA
[    5.315957] ata5.00: configured for UDMA/133
[    5.316356] sd 4:0:0:0: [sdb] 160086528 512-byte hardware sectors 
(81964 MB)
[    5.316448] sd 4:0:0:0: [sdb] Write Protect is off
[    5.316526] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.316543] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    5.316684] sd 4:0:0:0: [sdb] 160086528 512-byte hardware sectors 
(81964 MB)
[    5.316772] sd 4:0:0:0: [sdb] Write Protect is off
[    5.316850] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.316865] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    5.316960]  sdb: sdb2 < sdb5 sdb6 sdb7 sdb8 >
[    5.404184] sd 4:0:0:0: [sdb] Attached SCSI disk

It is this sata controller:
00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID 
Controller (rev 80)
    Subsystem: Micro-Star International Co., Ltd. K8T Neo 2 Motherboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 128
    Interrupt: pin B routed to IRQ 20
    Region 0: I/O ports at dc00 [size=8]
    Region 1: I/O ports at d800 [size=4]
    Region 2: I/O ports at d400 [size=8]
    Region 3: I/O ports at d000 [size=4]
    Region 4: I/O ports at cc00 [size=16]
    Region 5: I/O ports at c800 [size=256]
    Capabilities: [c0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

This is the disk:
quark:~# hdparm -i /dev/sdb

/dev/sdb:

 Model=Maxtor 6Y080M0                          , FwRev=YAR511W0, 
SerialNo=Y236DHAC           
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=DualPortCache, BuffSize=7936kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=160086528
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
 AdvancedPM=yes: disabled (255) WriteCache=enabled
 Drive conforms to: ATA/ATAPI-7 T13 1532D revision 0:  ATA/ATAPI-1 
ATA/ATAPI-2 ATA/ATAPI-3 ATA/ATAPI-4 ATA/ATAPI-5 ATA/ATAPI-6 ATA/ATAPI-7

 * signifies the current active mode

Is there any other info that can help? Please ask.
I don't understand the error codes, so have no clue why or what fails.
I would welcome suggestions how to get this disk back online next time 
this happens. The other sata connection on this controller is unused, 
but the PATA at 0:0:f.1 is used, so if there's something I can do to the 
controller without disturbing the PATA... (I'm thinking power-down the 
disk and/or controller using the command line)

I'm not really keen on testing patches, because this is my home server 
and the rest of the family will not thank me for experimenting.

Thanks,
Jan Evert



--------------ms040602080208020500080009
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIO7jCC
B3MwggVboAMCAQICAQMwDQYJKoZIhvcNAQEFBQAwgaUxCzAJBgNVBAYTAk5MMRMwEQYDVQQI
EwpHZWxkZXJsYW5kMRMwEQYDVQQHEwpIYXJkZXJ3aWprMRwwGgYDVQQKExNKLkUuIHZhbiBH
cm9vdGhlZXN0MSEwHwYDVQQDExhKYW4gRXZlcnQgdmFuIEdyb290aGVlc3QxKzApBgkqhkiG
9w0BCQEWHGouZS52YW4uZ3Jvb3RoZWVzdEBjYWl3YXkubmwwHhcNMDgwNDA4MDc1MTMxWhcN
MDkwNDA4MDc1MTMxWjCBpTELMAkGA1UEBhMCTkwxEzARBgNVBAgTCkdlbGRlcmxhbmQxEzAR
BgNVBAcTCkhhcmRlcndpamsxHDAaBgNVBAoTE0ouRS4gdmFuIEdyb290aGVlc3QxITAfBgNV
BAMTGEphbiBFdmVydCB2YW4gR3Jvb3RoZWVzdDErMCkGCSqGSIb3DQEJARYcai5lLnZhbi5n
cm9vdGhlZXN0QGNhaXdheS5ubDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMg4
3wenc42l/YlQzGBogfqvlBH0A/3MvVw/9Fa2hPDTs/sJ+iNiiKHKBn7GhjMf3VO4bjFInbPc
ZG0/b/A9bbvhRaNIAZmy2yz8IbFxU16g19cByyFKSEGbknS2r6fXMcCi02l65ZBmHV1XBB7M
62GRo0TKWIqOY00AR3ujF9pAzARLSBW92Ykf6jIzgtliGLt6YO+EZVHNUHcV+CA2kR/HXfju
M7+XOW+1IKSJyQ2aIlKBCtryxki/LqABTTL06jzJl+QW1oa7AIHhwI13qqyJfynTYrgAIwYS
92H6Cv+J2Buxykk9vBb/L73q+VdGmLw2z/6gDsjQOmk+WpICDZLNs+aI5W4UCNoE1rYCFPki
SI00TN/lAQXsp1mtNXs10RIW2OF2l0/ebM7Q6l4vj7l4LKjR/Qe3Yu3PzqBdDvaYeGMMpK2Q
kSvKfvA+gQCRVw3W+9V3GgSiQkFcUmM1gNCjwHIoEwfRaU9iionE5VHSsjm8DoTtjdeq1mBE
iFfsBQOkewAS2W3JFjGqOAYSh1UPgF57xdPzgjIzlnhji/NM3yy/9LCSZhVyf9eqZ7HvfI6s
nYcaZJosM+x96iauOwJF1GM/DABsIAxZPvkXMMHjrQGW/iA4Ik4IgSa3ueP+mzgfwsdQjRqX
oABun/mK/G3gJwJE2YsyYyawphg31kINAgMBAAGjggGqMIIBpjAJBgNVHRMEAjAAMBEGCWCG
SAGG+EIBAQQEAwIEsDArBglghkgBhvhCAQ0EHhYcVGlueUNBIEdlbmVyYXRlZCBDZXJ0aWZp
Y2F0ZTAdBgNVHQ4EFgQUZ/nkxP99q4jayO32sIUgzK3Ns7owgdoGA1UdIwSB0jCBz4AUloS2
O/+9zbmqj22/Ad/RDl49RnmhgaukgagwgaUxCzAJBgNVBAYTAk5MMRMwEQYDVQQIEwpHZWxk
ZXJsYW5kMRMwEQYDVQQHEwpIYXJkZXJ3aWprMRwwGgYDVQQKExNKLkUuIHZhbiBHcm9vdGhl
ZXN0MSEwHwYDVQQDExhKYW4gRXZlcnQgdmFuIEdyb290aGVlc3QxKzApBgkqhkiG9w0BCQEW
HGouZS52YW4uZ3Jvb3RoZWVzdEBjYWl3YXkubmyCCQCET9jqLUI66zAnBgNVHRIEIDAegRxq
LmUudmFuLmdyb290aGVlc3RAY2Fpd2F5Lm5sMCcGA1UdEQQgMB6BHGouZS52YW4uZ3Jvb3Ro
ZWVzdEBjYWl3YXkubmwwCwYDVR0PBAQDAgWgMA0GCSqGSIb3DQEBBQUAA4ICAQA2mHVdS8TG
hiV43nucHfmtqg57uO3xQr4epgXidUMQHIzkuDAeXSz1pjQ/QtEuOXxJzdhEk3Y099m5syma
7A3pvMowWBckOTjtfAA8gviY47fjFwTGSm37nUkUG5ndXrmhdSriLwypa6yF2vFgJZ5EXfox
w2Fm6U0IWYWdKH6HAiyQYLiQ64FaeUYu5vRpzbMAUQ9he2gelIGs5hpNMwT9GV78i6P1IE5D
wNdDiwurz53F4vgpH5/TGuyHfoe2H3hVeZLGpcjGv6oQbdtdldHltwzyc4rDSGTQOmLef48j
CR91ijKyULmvFm9VjB64ddmtWqJQg7nmwb39LnrgVkrkbduwoA2+1e7BAS82O44bFaVlT2Pq
EU9lLbKpGEcSTjcEZAzGZHGpG4MHQJZxxnh3YCUd2v7H0GFTiq21elgwlEKCuTHkTFKH6z8Y
bTA1wI7o3PKHSkRI7vXJ/rOths4U7TNxuIK0rP5aP1KoRkHsVm57W0Up0UojaNQxOBSU62cb
CeU4bThZekJ/HfBj6Vo0cWFFA0PGIkAbQKTKnlYzJC9mgWl5M+Fw0MiX9ybs94qj8lfIkIPI
bqhSwzZQcxKcm9ZGVoGbrTSEIhrlXxhQSC8OSmW229J2fNFuxrHZdZbTtERmqCGriDFKrObe
/TMrfVLQ3J19V28VMPyWoSPsFTCCB3MwggVboAMCAQICAQMwDQYJKoZIhvcNAQEFBQAwgaUx
CzAJBgNVBAYTAk5MMRMwEQYDVQQIEwpHZWxkZXJsYW5kMRMwEQYDVQQHEwpIYXJkZXJ3aWpr
MRwwGgYDVQQKExNKLkUuIHZhbiBHcm9vdGhlZXN0MSEwHwYDVQQDExhKYW4gRXZlcnQgdmFu
IEdyb290aGVlc3QxKzApBgkqhkiG9w0BCQEWHGouZS52YW4uZ3Jvb3RoZWVzdEBjYWl3YXku
bmwwHhcNMDgwNDA4MDc1MTMxWhcNMDkwNDA4MDc1MTMxWjCBpTELMAkGA1UEBhMCTkwxEzAR
BgNVBAgTCkdlbGRlcmxhbmQxEzARBgNVBAcTCkhhcmRlcndpamsxHDAaBgNVBAoTE0ouRS4g
dmFuIEdyb290aGVlc3QxITAfBgNVBAMTGEphbiBFdmVydCB2YW4gR3Jvb3RoZWVzdDErMCkG
CSqGSIb3DQEJARYcai5lLnZhbi5ncm9vdGhlZXN0QGNhaXdheS5ubDCCAiIwDQYJKoZIhvcN
AQEBBQADggIPADCCAgoCggIBAMg43wenc42l/YlQzGBogfqvlBH0A/3MvVw/9Fa2hPDTs/sJ
+iNiiKHKBn7GhjMf3VO4bjFInbPcZG0/b/A9bbvhRaNIAZmy2yz8IbFxU16g19cByyFKSEGb
knS2r6fXMcCi02l65ZBmHV1XBB7M62GRo0TKWIqOY00AR3ujF9pAzARLSBW92Ykf6jIzgtli
GLt6YO+EZVHNUHcV+CA2kR/HXfjuM7+XOW+1IKSJyQ2aIlKBCtryxki/LqABTTL06jzJl+QW
1oa7AIHhwI13qqyJfynTYrgAIwYS92H6Cv+J2Buxykk9vBb/L73q+VdGmLw2z/6gDsjQOmk+
WpICDZLNs+aI5W4UCNoE1rYCFPkiSI00TN/lAQXsp1mtNXs10RIW2OF2l0/ebM7Q6l4vj7l4
LKjR/Qe3Yu3PzqBdDvaYeGMMpK2QkSvKfvA+gQCRVw3W+9V3GgSiQkFcUmM1gNCjwHIoEwfR
aU9iionE5VHSsjm8DoTtjdeq1mBEiFfsBQOkewAS2W3JFjGqOAYSh1UPgF57xdPzgjIzlnhj
i/NM3yy/9LCSZhVyf9eqZ7HvfI6snYcaZJosM+x96iauOwJF1GM/DABsIAxZPvkXMMHjrQGW
/iA4Ik4IgSa3ueP+mzgfwsdQjRqXoABun/mK/G3gJwJE2YsyYyawphg31kINAgMBAAGjggGq
MIIBpjAJBgNVHRMEAjAAMBEGCWCGSAGG+EIBAQQEAwIEsDArBglghkgBhvhCAQ0EHhYcVGlu
eUNBIEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAdBgNVHQ4EFgQUZ/nkxP99q4jayO32sIUgzK3N
s7owgdoGA1UdIwSB0jCBz4AUloS2O/+9zbmqj22/Ad/RDl49RnmhgaukgagwgaUxCzAJBgNV
BAYTAk5MMRMwEQYDVQQIEwpHZWxkZXJsYW5kMRMwEQYDVQQHEwpIYXJkZXJ3aWprMRwwGgYD
VQQKExNKLkUuIHZhbiBHcm9vdGhlZXN0MSEwHwYDVQQDExhKYW4gRXZlcnQgdmFuIEdyb290
aGVlc3QxKzApBgkqhkiG9w0BCQEWHGouZS52YW4uZ3Jvb3RoZWVzdEBjYWl3YXkubmyCCQCE
T9jqLUI66zAnBgNVHRIEIDAegRxqLmUudmFuLmdyb290aGVlc3RAY2Fpd2F5Lm5sMCcGA1Ud
EQQgMB6BHGouZS52YW4uZ3Jvb3RoZWVzdEBjYWl3YXkubmwwCwYDVR0PBAQDAgWgMA0GCSqG
SIb3DQEBBQUAA4ICAQA2mHVdS8TGhiV43nucHfmtqg57uO3xQr4epgXidUMQHIzkuDAeXSz1
pjQ/QtEuOXxJzdhEk3Y099m5syma7A3pvMowWBckOTjtfAA8gviY47fjFwTGSm37nUkUG5nd
XrmhdSriLwypa6yF2vFgJZ5EXfoxw2Fm6U0IWYWdKH6HAiyQYLiQ64FaeUYu5vRpzbMAUQ9h
e2gelIGs5hpNMwT9GV78i6P1IE5DwNdDiwurz53F4vgpH5/TGuyHfoe2H3hVeZLGpcjGv6oQ
bdtdldHltwzyc4rDSGTQOmLef48jCR91ijKyULmvFm9VjB64ddmtWqJQg7nmwb39LnrgVkrk
bduwoA2+1e7BAS82O44bFaVlT2PqEU9lLbKpGEcSTjcEZAzGZHGpG4MHQJZxxnh3YCUd2v7H
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
AA==
--------------ms040602080208020500080009--
