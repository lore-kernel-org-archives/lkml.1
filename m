Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbYDVWoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbYDVWoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933618AbYDVWoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:44:38 -0400
Received: from lucidpixels.com ([75.144.35.66]:57184 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610AbYDVWof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:44:35 -0400
Date: Tue, 22 Apr 2008 18:44:33 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: From 2.6.24 -> 2.6.25, lost audio (snd-hda-intel)
Message-ID: <alpine.DEB.1.10.0804221822520.6366@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-469537869-1208904273=:9269"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-469537869-1208904273=:9269
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

Motherboard: A-Bit AWD9-MAX
Using 2.6.24, everything is fine, using 2.6.25, no audio (used make 
oldconfig)..
Kernel configs used attached.

I did not see any errors of any kind it just did not play any audio, I 
booted back to 2.6.24, everything working fine again.

The second one I enabled debugging.

[   11.437849] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[   11.437953] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   11.437956] ALSA sound/pci/hda/hda_intel.c:1813: chipset global capabilities = 0x4401
[   11.445263] ALSA sound/pci/hda/hda_intel.c:749: codec_mask = 0x1
[   11.447178] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[   11.447940] ALSA sound/pci/hda/hda_codec.c:2860: autoconfig: line_outs=3 (0x14/0x16/0x17/0x0/0x0)
[   11.447942] ALSA sound/pci/hda/hda_codec.c:2864:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   11.447944] ALSA sound/pci/hda/hda_codec.c:2868:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   11.447946] ALSA sound/pci/hda/hda_codec.c:2869:    mono: mono_out=0x0
[   11.447948] ALSA sound/pci/hda/hda_codec.c:2877:    inputs: mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x1c, aux=0x0
[   11.471616] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Side Playback Volume, skipped
[   11.471699] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Headphone Playback Volume, skipped
[   11.471788] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Speaker Playback Volume, skipped
[   11.471877] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Mono Playback Volume, skipped
[   11.471962] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Line-Out Playback Volume, skipped
[   11.472053] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Side Playback Switch, skipped
[   11.472137] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Speaker Playback Switch, skipped
[   11.472226] ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Mono Playback Switch, skipped

When trying to play a video with mplayer:

[   85.349302] ALSA sound/pci/hda/hda_intel.c:1293: azx_pcm_prepare: bufsize=0x10000, fragsize=0x2000, format=0x31
[   85.349487] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x31
[   85.351030] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x31
[   85.353029] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x31
[   85.355029] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x31
[   85.359725] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x2, stream=0x0, channel=0, format=0x0
[   85.361028] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4, stream=0x0, channel=0, format=0x0
[   85.363028] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5, stream=0x0, channel=0, format=0x0
[   85.365028] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x6, stream=0x0, channel=0, format=0x0
[  117.314646] ALSA sound/pci/hda/hda_intel.c:1293: azx_pcm_prepare: bufsize=0x10000, fragsize=0x2000, format=0x31
[  117.314757] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x31
[  117.316168] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x31
[  117.318167] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x31
[  117.320167] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x31
[  127.698682] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x2, stream=0x0, channel=0, format=0x0
[  127.700590] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4, stream=0x0, channel=0, format=0x0
[  127.702590] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5, stream=0x0, channel=0, format=0x0
[  127.704590] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x6, stream=0x0, channel=0, format=0x0
[  129.560026] ALSA sound/pci/hda/hda_intel.c:1293: azx_pcm_prepare: bufsize=0x10000, fragsize=0x2000, format=0x31
[  129.560215] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x31
[  129.561306] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x31
[  129.563306] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x31
[  129.565306] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x31
[  131.581178] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x2, stream=0x0, channel=0, format=0x0
[  131.583000] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4, stream=0x0, channel=0, format=0x0
[  131.584999] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5, stream=0x0, channel=0, format=0x0
[  131.587000] ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x6, stream=0x0, channel=0, format=0x0

lspci output:

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
         Subsystem: ABIT Computer Corp. Unknown device 107a
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at fdff8000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                         ExtTag- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                         ClockPM- Suprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
         Capabilities: [100] Virtual Channel <?>
         Capabilities: [130] Root Complex Link <?>
         Kernel driver in use: HDA Intel
         Kernel modules: snd-hda-intel
00: 86 80 d8 27 06 00 10 00 01 00 03 04 08 00 00 00
10: 04 80 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 7b 14 7a 10
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00


---1463747160-469537869-1208904273=:9269
Content-Type: APPLICATION/octet-stream; name=config-2.6.25-1.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.1.10.0804221844330.9269@p34.internal.lan>
Content-Description: 
Content-Disposition: attachment; filename=config-2.6.25-1.bz2

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

---1463747160-469537869-1208904273=:9269
Content-Type: APPLICATION/octet-stream; name=config-2.6.25-2.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.1.10.0804221844331.9269@p34.internal.lan>
Content-Description: 
Content-Disposition: attachment; filename=config-2.6.25-2.bz2

QlpoOTFBWSZTWUIdLD0ACTLfgGgQXOf/+j////C////gYCNcAAD1gdAVxntw
OUgEHyT6C7uOAAJjt3bZ3DEV3dc6odVrb7r28knp5m0HRdgVprVafTTvtkiA
+7VrighIq5tQ4u9etvfd3R70NTEATTRoAEmghqDU9QyNNB6anqeoDQBpoCE0
TEBBGpTRmoAANMgB6gACU0EUMSnip+TKhk8gymRkM0T1MANAjTNBJpRBBNAT
TRTyjwo/Ug0aAAB6gNGhoJJT1NTU8VPMU9KfqelPU0/SNTPVHqek9TT1PSbU
8p6mhoAASIgmgCCBJ6JTzVDQNAaAAAAHWG31/URYcMYwf3EiksxSxMNdEKMJ
nz+o6czVPZk+TurCtYovG/Rgn0bEAM48L/rEohu5Q+XyblD6db2E6GBO7uuA
yyoKCwUFkUWCkWdmPhiZ1tZlIoFVbawUtqqqysKCCMFR9DUFWHclZlEYQu9K
wVFRQUURRi4asTVIGEhhWSIikbZUUFhBZBTCVwkIaYosEFEUEcNdffYYRSKH
uSujFqCgRQAo6uEjikBtILJhkJUwxYC227NArKpmzOGwUsSpWBWQWosIqlSq
yVqLFILEskKkk+DCUmCW1WCKMGstb77V1aCKubKLKtp8cYMSRYiqp9hlVEXG
4sKJAxLMFF54uPjjPLjrldbQyhY6MCzKBYcWzFtsKjKqUrRXNCpvZSqucYYL
KlFSDbbaog2jbaWFUra1rWjHpZKhLa+HTt8E+fn5931c/pfw8OVx5Ofm83SE
kkRwg9DHU0Q3fGp9EZu9UUe+IJmrnlHxsnZkuL2MygsPLhYGjrb5ph/Iz6+6
7cb+hyybPDUwOM13e780g2Opa4e7+t7BCkD/O8SGjsGsoG3LhA3Q+Q4H4/E5
9cYr+DhD4pEN+r5RNbyfZZx9zflA/l8yk+35zlaw/oiyIVZYXsCx7/f8MfpE
zscH5tQJ89TSerj/Cz76whw7Da2f6Kpwurhj9y5Pgn0gdkTG7t8msJlo5NYW
OrkzYamVt5RcCtlAW3sLHnTMx0++zSMe3LWqI2CZaC2aLwcRpSpjF1Wyya4G
U/v/CbyqMy7pjQNr4NsXA9KDPWdtrLjb2buHZH4Lr3xn1kZ8prpEbGuvv09L
srND/Vp3/xoyyzLqswtksxHbjPFe2gPIGlwjN2ps1K4FkRVgkIx3mbQ0oozd
fCy6anUXDGtrXYpsvW/LqVutXZEyFzDU8qkhVy4pTXhONRDQ3M18bXDGfLHc
2FE6WLWtNl0QLWTnLqkLTsVG1bpSPK+9GFFdyKt5w5cjOSr9GMWbwe7dtzrw
zrC+/jJ94fNpGyWiLnaWMpwTo89R1SOaXLceM67iNKkt2Mi+LHXu3pISupgY
izQ9GZmXg13c8AQuwZc/p3eTdlwtlBMGFShLdAa9BqLv83OeyT/PezXKFeGU
YtM+3RPYm+C8/O7SU+zUvBnvKlX7TDjU1b8m8eO2BXhtirT4t41+euMNPKrW
/SWs5wtfFNrGY3MdbRcLHV426jbbfTHEzuKzzPbPGtVpDZ06tjdWjUAkkjs9
OuHmg2qzAd90gCSSITcGfXln1tCiEmDdDbFLJNTv7G532/t/qg+KSQJLhP8/
gwdPdx5mx17Ti5yqr3aqJsWXTTpvpMVv3bmC0YYYooi62Ydn68sDg38X0re1
rmmgLe4Nj/UalCTZaZQHdQ5DBVqLw7kCAMXVP4yiTCAkWmy/2WaiEIohblbf
pazxDoIMb/MJMlj1mHLl/Fhec+H9vwmbZdGqj0ZfM1VedfPxtR747xrmYKkc
UvaViilpiwx4cl2/Cocxn4d3b0Vswo2U8aUYq20vCxMDb9mElRwC7vn276y2
Ieli8LV6DuXk7IeSyHWOckuuastOLR8Zhj7IJXKrS9injvq073ZyJTiBQMpP
suXlPYhf8N3SynEFHdnXOdQt9WIm5E1hMcpGGFAChxmt0WBaK8VEHkrxHX5P
uvgeS5Wjy7Lx3aVsr25bXePNvGxJnIy07UAeWN4Ye5AswxgCMamLVAD3ezXL
bYY+TIiwY4OCDOkiVRiUxwyu0GRKcHke+CPATa38bIsaL1dG3fb3YdNRzC28
LIFyicJjMa9ep81a3i6uGe/E2kedph/b74iGKWKaefmvi2OUAN7CUyhTApQE
43lc5TlsWluC1Wr0LGx2ZHdOlE8Tg6k4LMrjYCS+dbIsr1cpFlfNqwz6P7/d
fNYeKfVQpAr0zIgT4KJBA+SEOg48lY4xXY+JGTyDfX+8GKGGVOx2GueVvInT
WcEk8AYE/Y4GEN923GWM8KwEdBdkWz08PIkXGwRuXliO1KN2VL1Yu9h8ip/U
FbkEgBwGAiAVCW/NjgBhBFuJYClCbNA6YN7Owjmf7x5AKShC7HTsvnUIsSnd
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
2ejSkkIPErZeKmONNCJQ/+LuSKcKEghDpYeg

---1463747160-469537869-1208904273=:9269--
