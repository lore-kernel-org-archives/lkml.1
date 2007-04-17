Return-Path: <linux-kernel-owner+w=401wt.eu-S1030823AbXDQSBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823AbXDQSBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031258AbXDQSBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:01:25 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:59462 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030823AbXDQSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:01:23 -0400
Date: Tue, 17 Apr 2007 14:00:01 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, perex@suse.cz, alsa-devel@alsa-project.org
Subject: [PATCH] sound: convert "sound" subdirectory to UTF-8
Message-ID: <alpine.DEB.0.83.0704171356400.914@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1875672472-1370536846-1176832767=:914"
Content-ID: <alpine.DEB.0.83.0704171359300.914@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1875672472-1370536846-1176832767=:914
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.0.83.0704171359301.914@sigma.j-a-k-j.com>

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Convert the "sound" subdirectory to UTF-8. The following files are 
changed.

sound/oss/{trident.c,es1371.c,pas2_pcm.c}
sound/oss/emu10k1/{passthrough.h,passthrough.c}
sound/pci/mixart/mixart.c

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I can't get my mail client to send in ISO-8859-1 explicitly instead of 
whatever it decides I want, so the actual patch is attached in 
octet-stream format. The below patch is just for reference and will very 
likely NOT work, unless this time it picks ISO-8859-1.

Also, since the patch includes both encodings, whichever encoding you 
select while viewing it will display one correct and one garbled line. 
However, the bytecodes -are- correct.

diff -uprN linux-2.6.21-rc7.orig/sound/oss/emu10k1/passthrough.c linux-2.6.21-rc7.mod/sound/oss/emu10k1/passthrough.c
--- linux-2.6.21-rc7.orig/sound/oss/emu10k1/passthrough.c	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/sound/oss/emu10k1/passthrough.c	2007-04-17 13:55:45.000000000 -0400
@@ -1,13 +1,13 @@
 /*
  **********************************************************************
  *     passthrough.c -- Emu10k1 digital passthrough
- *     Copyright (C) 2001  Juha Yrjölä <jyrjola@cc.hut.fi>
+ *     Copyright (C) 2001  Juha YrjÃ¶lÃ¤ <jyrjola@cc.hut.fi>
  *
  **********************************************************************
  *
  *     Date                 Author          Summary of changes
  *     ----                 ------          ------------------
- *     May 15, 2001	    Juha Yrjölä	    base code release
+ *     May 15, 2001	    Juha YrjÃ¶lÃ¤	    base code release
  *
  **********************************************************************
  *
diff -uprN linux-2.6.21-rc7.orig/sound/oss/emu10k1/passthrough.h linux-2.6.21-rc7.mod/sound/oss/emu10k1/passthrough.h
--- linux-2.6.21-rc7.orig/sound/oss/emu10k1/passthrough.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/sound/oss/emu10k1/passthrough.h	2007-04-17 13:55:45.000000000 -0400
@@ -1,13 +1,13 @@
 /*
  **********************************************************************
  *     passthrough.h -- Emu10k1 digital passthrough header file
- *     Copyright (C) 2001  Juha Yrjölä <jyrjola@cc.hut.fi>
+ *     Copyright (C) 2001  Juha YrjÃ¶lÃ¤ <jyrjola@cc.hut.fi>
  *
  **********************************************************************
  *
  *     Date                 Author          Summary of changes
  *     ----                 ------          ------------------
- *     May 15, 2001	    Juha Yrjölä     base code release
+ *     May 15, 2001	    Juha YrjÃ¶lÃ¤     base code release
  *
  **********************************************************************
  *
diff -uprN linux-2.6.21-rc7.orig/sound/oss/es1371.c linux-2.6.21-rc7.mod/sound/oss/es1371.c
--- linux-2.6.21-rc7.orig/sound/oss/es1371.c	2007-04-17 11:42:18.000000000 -0400
+++ linux-2.6.21-rc7.mod/sound/oss/es1371.c	2007-04-17 13:55:45.000000000 -0400
@@ -100,7 +100,7 @@
  *                       Tjeerd Mulder <tjeerd.mulder@fujitsu-siemens.com>
  *    05.01.2001   0.29  Hopefully updates will not be required anymore when Creative bumps
  *                       the CT5880 revision.
- *                       suggested by Stephan Müller <smueller@chronox.de>
+ *                       suggested by Stephan MÃ¼ller <smueller@chronox.de>
  *    31.01.2001   0.30  Register/Unregister gameport
  *                       Fix SETTRIGGER non OSS API conformity
  *    14.07.2001   0.31  Add list of laptops needing amplifier control
diff -uprN linux-2.6.21-rc7.orig/sound/oss/pas2_pcm.c linux-2.6.21-rc7.mod/sound/oss/pas2_pcm.c
--- linux-2.6.21-rc7.orig/sound/oss/pas2_pcm.c	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/sound/oss/pas2_pcm.c	2007-04-17 13:55:45.000000000 -0400
@@ -85,7 +85,7 @@ static int pcm_set_speed(int arg)
 	 * come from the SDK found on ftp.uwp.edu:/pub/msdos/proaudio/.
 	 *
 	 * I cleared bit 5 of these values, since that bit controls the master
-	 * mute flag. (Olav Wölfelschneider)
+	 * mute flag. (Olav WÃ¶lfelschneider)
 	 *
 	 */
 #if !defined NO_AUTO_FILTER_SET
diff -uprN linux-2.6.21-rc7.orig/sound/oss/trident.c linux-2.6.21-rc7.mod/sound/oss/trident.c
--- linux-2.6.21-rc7.orig/sound/oss/trident.c	2007-04-17 11:42:18.000000000 -0400
+++ linux-2.6.21-rc7.mod/sound/oss/trident.c	2007-04-17 13:55:45.000000000 -0400
@@ -18,7 +18,7 @@
  *	Ollie Lho <ollie@sis.com.tw> SiS 7018 Audio Core Support
  *	Ching-Ling Lee <cling-li@ali.com.tw> ALi 5451 Audio Core Support 
  *	Matt Wu <mattwu@acersoftech.com.cn> ALi 5451 Audio Core Support
- *	Peter Wächtler <pwaechtler@loewe-komp.de> CyberPro5050 support
+ *	Peter WÃ¤chtler <pwaechtler@loewe-komp.de> CyberPro5050 support
  *      Muli Ben-Yehuda <mulix@mulix.org>
  *
  *
@@ -89,7 +89,7 @@
  *	use set_current_state, properly release resources on failure in
  *	trident_probe, get rid of check_region
  *  v0.14.9c
- *	August 10 2001 Peter Wächtler <pwaechtler@loewe-komp.de>
+ *	August 10 2001 Peter WÃ¤chtler <pwaechtler@loewe-komp.de>
  *	added support for Tvia (formerly Integraphics/IGST) CyberPro5050
  *	this chip is often found in settop boxes (combined video+audio)
  *  v0.14.9b
diff -uprN linux-2.6.21-rc7.orig/sound/pci/mixart/mixart.c linux-2.6.21-rc7.mod/sound/pci/mixart/mixart.c
--- linux-2.6.21-rc7.orig/sound/pci/mixart/mixart.c	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/sound/pci/mixart/mixart.c	2007-04-17 13:55:45.000000000 -0400
@@ -472,7 +472,7 @@ static int snd_mixart_prepare(struct snd
 	struct snd_mixart *chip = snd_pcm_substream_chip(subs);
 	struct mixart_stream *stream = subs->runtime->private_data;
 
-	/* TODO de façon non bloquante, réappliquer les hw_params (rate, bits, codec) */
+	/* TODO de faÃ§on non bloquante, rÃ©appliquer les hw_params (rate, bits, codec) */
 
 	snd_printdd("snd_mixart_prepare\n");
 
--1875672472-1370536846-1176832767=:914
Content-Type: APPLICATION/octet-stream; name=patch-sound.bin
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.83.0704171400010.914@sigma.j-a-k-j.com>
Content-Description: 
Content-Disposition: attachment; filename=patch-sound.bin

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvc291bmQvb3NzL2Vt
dTEwazEvcGFzc3Rocm91Z2guYyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9zb3Vu
ZC9vc3MvZW11MTBrMS9wYXNzdGhyb3VnaC5jCi0tLSBsaW51eC0yLjYuMjEt
cmM3Lm9yaWcvc291bmQvb3NzL2VtdTEwazEvcGFzc3Rocm91Z2guYwkyMDA3
LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42
LjIxLXJjNy5tb2Qvc291bmQvb3NzL2VtdTEwazEvcGFzc3Rocm91Z2guYwky
MDA3LTA0LTE3IDEzOjU1OjQ1LjAwMDAwMDAwMCAtMDQwMApAQCAtMSwxMyAr
MSwxMyBAQAogLyoKICAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAgKiAg
ICAgcGFzc3Rocm91Z2guYyAtLSBFbXUxMGsxIGRpZ2l0YWwgcGFzc3Rocm91
Z2gKLSAqICAgICBDb3B5cmlnaHQgKEMpIDIwMDEgIEp1aGEgWXJq9mzkIDxq
eXJqb2xhQGNjLmh1dC5maT4KKyAqICAgICBDb3B5cmlnaHQgKEMpIDIwMDEg
IEp1aGEgWXJqw7Zsw6QgPGp5cmpvbGFAY2MuaHV0LmZpPgogICoKICAqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqCiAgKgogICogICAgIERhdGUgICAgICAg
ICAgICAgICAgIEF1dGhvciAgICAgICAgICBTdW1tYXJ5IG9mIGNoYW5nZXMK
ICAqICAgICAtLS0tICAgICAgICAgICAgICAgICAtLS0tLS0gICAgICAgICAg
LS0tLS0tLS0tLS0tLS0tLS0tCi0gKiAgICAgTWF5IDE1LCAyMDAxCSAgICBK
dWhhIFlyavZs5AkgICAgYmFzZSBjb2RlIHJlbGVhc2UKKyAqICAgICBNYXkg
MTUsIDIwMDEJICAgIEp1aGEgWXJqw7Zsw6QJICAgIGJhc2UgY29kZSByZWxl
YXNlCiAgKgogICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICAqCmRpZmYg
LXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL3NvdW5kL29zcy9lbXUxMGsx
L3Bhc3N0aHJvdWdoLmggbGludXgtMi42LjIxLXJjNy5tb2Qvc291bmQvb3Nz
L2VtdTEwazEvcGFzc3Rocm91Z2guaAotLS0gbGludXgtMi42LjIxLXJjNy5v
cmlnL3NvdW5kL29zcy9lbXUxMGsxL3Bhc3N0aHJvdWdoLmgJMjAwNy0wMi0w
NCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1y
YzcubW9kL3NvdW5kL29zcy9lbXUxMGsxL3Bhc3N0aHJvdWdoLmgJMjAwNy0w
NC0xNyAxMzo1NTo0NS4wMDAwMDAwMDAgLTA0MDAKQEAgLTEsMTMgKzEsMTMg
QEAKIC8qCiAgKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogICogICAgIHBh
c3N0aHJvdWdoLmggLS0gRW11MTBrMSBkaWdpdGFsIHBhc3N0aHJvdWdoIGhl
YWRlciBmaWxlCi0gKiAgICAgQ29weXJpZ2h0IChDKSAyMDAxICBKdWhhIFly
avZs5CA8anlyam9sYUBjYy5odXQuZmk+CisgKiAgICAgQ29weXJpZ2h0IChD
KSAyMDAxICBKdWhhIFlyasO2bMOkIDxqeXJqb2xhQGNjLmh1dC5maT4KICAq
CiAgKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKgogICoKICAqICAgICBEYXRl
ICAgICAgICAgICAgICAgICBBdXRob3IgICAgICAgICAgU3VtbWFyeSBvZiBj
aGFuZ2VzCiAgKiAgICAgLS0tLSAgICAgICAgICAgICAgICAgLS0tLS0tICAg
ICAgICAgIC0tLS0tLS0tLS0tLS0tLS0tLQotICogICAgIE1heSAxNSwgMjAw
MQkgICAgSnVoYSBZcmr2bOQgICAgIGJhc2UgY29kZSByZWxlYXNlCisgKiAg
ICAgTWF5IDE1LCAyMDAxCSAgICBKdWhhIFlyasO2bMOkICAgICBiYXNlIGNv
ZGUgcmVsZWFzZQogICoKICAqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAg
KgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9zb3VuZC9vc3Mv
ZXMxMzcxLmMgbGludXgtMi42LjIxLXJjNy5tb2Qvc291bmQvb3NzL2VzMTM3
MS5jCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvc291bmQvb3NzL2VzMTM3
MS5jCTIwMDctMDQtMTcgMTE6NDI6MTguMDAwMDAwMDAwIC0wNDAwCisrKyBs
aW51eC0yLjYuMjEtcmM3Lm1vZC9zb3VuZC9vc3MvZXMxMzcxLmMJMjAwNy0w
NC0xNyAxMzo1NTo0NS4wMDAwMDAwMDAgLTA0MDAKQEAgLTEwMCw3ICsxMDAs
NyBAQAogICogICAgICAgICAgICAgICAgICAgICAgIFRqZWVyZCBNdWxkZXIg
PHRqZWVyZC5tdWxkZXJAZnVqaXRzdS1zaWVtZW5zLmNvbT4KICAqICAgIDA1
LjAxLjIwMDEgICAwLjI5ICBIb3BlZnVsbHkgdXBkYXRlcyB3aWxsIG5vdCBi
ZSByZXF1aXJlZCBhbnltb3JlIHdoZW4gQ3JlYXRpdmUgYnVtcHMKICAqICAg
ICAgICAgICAgICAgICAgICAgICB0aGUgQ1Q1ODgwIHJldmlzaW9uLgotICog
ICAgICAgICAgICAgICAgICAgICAgIHN1Z2dlc3RlZCBieSBTdGVwaGFuIE38
bGxlciA8c211ZWxsZXJAY2hyb25veC5kZT4KKyAqICAgICAgICAgICAgICAg
ICAgICAgICBzdWdnZXN0ZWQgYnkgU3RlcGhhbiBNw7xsbGVyIDxzbXVlbGxl
ckBjaHJvbm94LmRlPgogICogICAgMzEuMDEuMjAwMSAgIDAuMzAgIFJlZ2lz
dGVyL1VucmVnaXN0ZXIgZ2FtZXBvcnQKICAqICAgICAgICAgICAgICAgICAg
ICAgICBGaXggU0VUVFJJR0dFUiBub24gT1NTIEFQSSBjb25mb3JtaXR5CiAg
KiAgICAxNC4wNy4yMDAxICAgMC4zMSAgQWRkIGxpc3Qgb2YgbGFwdG9wcyBu
ZWVkaW5nIGFtcGxpZmllciBjb250cm9sCmRpZmYgLXVwck4gbGludXgtMi42
LjIxLXJjNy5vcmlnL3NvdW5kL29zcy9wYXMyX3BjbS5jIGxpbnV4LTIuNi4y
MS1yYzcubW9kL3NvdW5kL29zcy9wYXMyX3BjbS5jCi0tLSBsaW51eC0yLjYu
MjEtcmM3Lm9yaWcvc291bmQvb3NzL3BhczJfcGNtLmMJMjAwNy0wMi0wNCAx
Mzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcu
bW9kL3NvdW5kL29zcy9wYXMyX3BjbS5jCTIwMDctMDQtMTcgMTM6NTU6NDUu
MDAwMDAwMDAwIC0wNDAwCkBAIC04NSw3ICs4NSw3IEBAIHN0YXRpYyBpbnQg
cGNtX3NldF9zcGVlZChpbnQgYXJnKQogCSAqIGNvbWUgZnJvbSB0aGUgU0RL
IGZvdW5kIG9uIGZ0cC51d3AuZWR1Oi9wdWIvbXNkb3MvcHJvYXVkaW8vLgog
CSAqCiAJICogSSBjbGVhcmVkIGJpdCA1IG9mIHRoZXNlIHZhbHVlcywgc2lu
Y2UgdGhhdCBiaXQgY29udHJvbHMgdGhlIG1hc3RlcgotCSAqIG11dGUgZmxh
Zy4gKE9sYXYgV/ZsZmVsc2NobmVpZGVyKQorCSAqIG11dGUgZmxhZy4gKE9s
YXYgV8O2bGZlbHNjaG5laWRlcikKIAkgKgogCSAqLwogI2lmICFkZWZpbmVk
IE5PX0FVVE9fRklMVEVSX1NFVApkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1y
Yzcub3JpZy9zb3VuZC9vc3MvdHJpZGVudC5jIGxpbnV4LTIuNi4yMS1yYzcu
bW9kL3NvdW5kL29zcy90cmlkZW50LmMKLS0tIGxpbnV4LTIuNi4yMS1yYzcu
b3JpZy9zb3VuZC9vc3MvdHJpZGVudC5jCTIwMDctMDQtMTcgMTE6NDI6MTgu
MDAwMDAwMDAwIC0wNDAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9zb3Vu
ZC9vc3MvdHJpZGVudC5jCTIwMDctMDQtMTcgMTM6NTU6NDUuMDAwMDAwMDAw
IC0wNDAwCkBAIC0xOCw3ICsxOCw3IEBACiAgKglPbGxpZSBMaG8gPG9sbGll
QHNpcy5jb20udHc+IFNpUyA3MDE4IEF1ZGlvIENvcmUgU3VwcG9ydAogICoJ
Q2hpbmctTGluZyBMZWUgPGNsaW5nLWxpQGFsaS5jb20udHc+IEFMaSA1NDUx
IEF1ZGlvIENvcmUgU3VwcG9ydCAKICAqCU1hdHQgV3UgPG1hdHR3dUBhY2Vy
c29mdGVjaC5jb20uY24+IEFMaSA1NDUxIEF1ZGlvIENvcmUgU3VwcG9ydAot
ICoJUGV0ZXIgV+RjaHRsZXIgPHB3YWVjaHRsZXJAbG9ld2Uta29tcC5kZT4g
Q3liZXJQcm81MDUwIHN1cHBvcnQKKyAqCVBldGVyIFfDpGNodGxlciA8cHdh
ZWNodGxlckBsb2V3ZS1rb21wLmRlPiBDeWJlclBybzUwNTAgc3VwcG9ydAog
ICogICAgICBNdWxpIEJlbi1ZZWh1ZGEgPG11bGl4QG11bGl4Lm9yZz4KICAq
CiAgKgpAQCAtODksNyArODksNyBAQAogICoJdXNlIHNldF9jdXJyZW50X3N0
YXRlLCBwcm9wZXJseSByZWxlYXNlIHJlc291cmNlcyBvbiBmYWlsdXJlIGlu
CiAgKgl0cmlkZW50X3Byb2JlLCBnZXQgcmlkIG9mIGNoZWNrX3JlZ2lvbgog
ICogIHYwLjE0LjljCi0gKglBdWd1c3QgMTAgMjAwMSBQZXRlciBX5GNodGxl
ciA8cHdhZWNodGxlckBsb2V3ZS1rb21wLmRlPgorICoJQXVndXN0IDEwIDIw
MDEgUGV0ZXIgV8OkY2h0bGVyIDxwd2FlY2h0bGVyQGxvZXdlLWtvbXAuZGU+
CiAgKglhZGRlZCBzdXBwb3J0IGZvciBUdmlhIChmb3JtZXJseSBJbnRlZ3Jh
cGhpY3MvSUdTVCkgQ3liZXJQcm81MDUwCiAgKgl0aGlzIGNoaXAgaXMgb2Z0
ZW4gZm91bmQgaW4gc2V0dG9wIGJveGVzIChjb21iaW5lZCB2aWRlbythdWRp
bykKICAqICB2MC4xNC45YgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcu
b3JpZy9zb3VuZC9wY2kvbWl4YXJ0L21peGFydC5jIGxpbnV4LTIuNi4yMS1y
YzcubW9kL3NvdW5kL3BjaS9taXhhcnQvbWl4YXJ0LmMKLS0tIGxpbnV4LTIu
Ni4yMS1yYzcub3JpZy9zb3VuZC9wY2kvbWl4YXJ0L21peGFydC5jCTIwMDct
MDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYu
MjEtcmM3Lm1vZC9zb3VuZC9wY2kvbWl4YXJ0L21peGFydC5jCTIwMDctMDQt
MTcgMTM6NTU6NDUuMDAwMDAwMDAwIC0wNDAwCkBAIC00NzIsNyArNDcyLDcg
QEAgc3RhdGljIGludCBzbmRfbWl4YXJ0X3ByZXBhcmUoc3RydWN0IHNuZAog
CXN0cnVjdCBzbmRfbWl4YXJ0ICpjaGlwID0gc25kX3BjbV9zdWJzdHJlYW1f
Y2hpcChzdWJzKTsKIAlzdHJ1Y3QgbWl4YXJ0X3N0cmVhbSAqc3RyZWFtID0g
c3Vicy0+cnVudGltZS0+cHJpdmF0ZV9kYXRhOwogCi0JLyogVE9ETyBkZSBm
YedvbiBub24gYmxvcXVhbnRlLCBy6WFwcGxpcXVlciBsZXMgaHdfcGFyYW1z
IChyYXRlLCBiaXRzLCBjb2RlYykgKi8KKwkvKiBUT0RPIGRlIGZhw6dvbiBu
b24gYmxvcXVhbnRlLCByw6lhcHBsaXF1ZXIgbGVzIGh3X3BhcmFtcyAocmF0
ZSwgYml0cywgY29kZWMpICovCiAKIAlzbmRfcHJpbnRkZCgic25kX21peGFy
dF9wcmVwYXJlXG4iKTsKIAo=

--1875672472-1370536846-1176832767=:914--
