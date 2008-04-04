Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbYDDKYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbYDDKYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 06:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYDDKX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 06:23:59 -0400
Received: from web26213.mail.ukl.yahoo.com ([217.12.10.209]:40418 "HELO
	web26213.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752778AbYDDKX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 06:23:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=e2B1+QRYUgbDXjR/q2G+K9iErI55nf3kBA2LANFbymC/4q5SS+XNbK7/oKRnkopKCS92ixD+sLHJ0ylBxo7aB8pIpHkYrCBau640agKUvvlJpZ3ib03R6DVP1I8xV9hD5DaVPDj3R8pWHVyoL5IktoaRbtiQd2IumbboF2FEkMg=;
X-YMail-OSG: nnvFPNQVM1mHIxR.joH01KKhrrA.Ftoju5Ta0K9OqgAvSBVKuvRbFlgqInFzZsHZFPKm6XQgUOyvGo5Ejf0paa8tP2uuoYuwXajNVACWPPJJjRnn24yEo6LFtr0-
X-Mailer: YahooMailWebService/0.7.185
Date: Fri, 4 Apr 2008 10:23:55 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: [PATCH]  jffs2 summary allocation
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1264241528-1207304635=:37644"
Message-ID: <713171.37644.qm@web26213.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1264241528-1207304635=:37644
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I apply this patch to fix this oops.


Unable to handle kernel NULL pointer dereference at virtual address 0000000=
0
pgd =3D c0004000
[00000000] *pgd=3D00000000
stopped custom tracer.
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.24-rc5-rt1 #37)
PC is at dma_cache_maint+0x40/0x80
LR is at atmel_spi_transfer+0x94/0x178
pc : [<c002488c>]    lr : [<c013eedc>]    psr: 20000013
sp : c044db84  ip : c044db94  fp : c044db90
r10: ffffffff  r9 : 00000000  r8 : c04e4c00
r7 : c03ee310  r6 : c044dcfc  r5 : c109d3bc  r4 : c044dcd8
r3 : 00000000  r2 : 00000001  r1 : c109d7dc  r0 : c109d3bc
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005317f  Table: 20588000  DAC: 00000017
Process jffs2_gcd_mtd1 (pid: 313, stack limit =3D 0xc044c258)
Stack: (0xc044db84 to 0xc044e000)
db80:          c044dbb8 c044db94 c013eedc c002485c c04e4c00 c044dbbc c044dc=
fc
dba0: c044dc20 00000000 c044dcfc c044dca4 c044dbbc c013e124 c013ee58 000000=
00
dbc0: 00000001 dead4ead ffffffff ffffffff c02e7844 00000000 c01933d4 c044dc=
40
dbe0: c044dc40 c044dc48 c044dc48 c044dc24 00000000 005593e0 c018f8b4 c04460=
7c
dc00: 00000420 c044dc88 c044dc78 c01defa8 00000000 c018f8b4 c044dc7c c044dc=
7c
dc20: 00000000 00000001 dead4ead ffffffff ffffffff c02e7844 00000000 c01933=
d4
dc40: c044dc40 c044dc40 c044dc48 c044dc48 c044dc24 00000000 005593e0 c018f8=
b4
dc60: c044607c 00000420 c044dc88 c044dc78 c01defa8 00000000 c018f8b4 c044dc=
7c
dc80: c044dc7c 00a5f800 00000420 c0446000 00000420 000014bf c044dd50 c044dc=
a8
dca0: c013dcb0 c013e0c0 c0446024 c04e4c00 c109d3bc c0446000 00000000 000000=
04
dcc0: 20446000 ffffffff 00000000 00000000 c044dcf4 c044dcfc c109d3bc 000000=
00
dce0: 00000420 ffffffff ffffffff 00000000 00000000 c044dcfc c044dcd0 c044dc=
d0
dd00: c044dcf4 c04e4c00 00000000 c013e148 c044dc20 00000000 00000000 000000=
00
dd20: 00000000 00000000 00000000 00427fe0 00000000 c109d3bc 00427fe0 000003=
dc
dd40: 00000000 c044dd74 c044dd54 c013a00c c013db10 c044dd9c c109d3bc 000004=
20
dd60: 00000420 c04d9000 c044ddc8 c044dd78 c00e0724 c0139f74 c044dd9c c109d3=
bc
dd80: 00000002 c044de08 c04d93a0 00427c24 00000001 c044de10 00427c04 000000=
00
dda0: c044ed70 00427c04 c109d048 c04d9000 00000000 0000078c c056689c c044de=
44
ddc0: c044ddd0 c00e1f40 c00e04c0 00427c04 00000000 c044de18 00000000 c04d91=
cc
dde0: 000007fc 000007dc 20061985 000007fc 37fa2120 00000004 00000000 000003=
64
de00: 36d8bf4d b504e572 c044dde8 00000020 c109d000 000007dc 00000000 c044ed=
70
de20: c056689c 00000938 c04d9000 000008c8 000000c4 c04d91cc c044de84 c044de=
48
de40: c00d5ca0 c00e1c1c c044de68 c044de58 c04d91b4 000000c4 c044dec4 c044ed=
70
de60: c04d9000 000000c4 c04d91cc 000008c8 c044ed70 c044dec4 c044deac c044de=
88
de80: c00d6014 c00d5c1c c044ed70 000008c8 c0568950 c04d9000 c04d9000 c037bd=
e4
dea0: c044def4 c044deb0 c00da938 c00d5fe4 c04d92e8 c044c000 00000001 c044de=
c8
dec0: c014e3c0 000000c4 c04d92e8 c044ed70 c04e1ecc c0568950 c037bde4 c04d90=
00
dee0: c04d90dc c04d92e8 c044df48 c044def8 c00dc32c c00da8ec c044df04 c04d91=
94
df00: c04d9174 c04d91c4 000015e8 c044c000 c044df30 c044df20 c014ecfc c014e3=
7c
df20: 00000001 c039c3e0 c044c000 c04d9000 00000008 00000002 c044df4c c044df=
f4
df40: c044df4c c00dd730 c00dbdac 00000001 00000000 00000080 00000000 000000=
00
df60: 00000000 00000000 00000000 c044df98 c044df7c c0060ea0 c005bd74 c03240=
20
df80: 00000000 c0324020 00000000 c044dfac c044df9c c00326f4 c0060f78 000000=
00
dfa0: 00000000 c044dfb0 c001ff44 c00326c4 00000000 c04d9000 c00dd630 c00398=
18
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
dfe0: 00000000 00000000 00000000 c044dff8 c0039818 c00dd640 00000000 000000=
00
Backtrace:
[<c002484c>] (dma_cache_maint+0x0/0x80) from [<c013eedc>] (atmel_spi_transf=
er+0x94/0x178)
[<c013ee48>] (atmel_spi_transfer+0x0/0x178) from [<c013e124>] (spi_sync+0x7=
4/0x98)
[<c013e0b0>] (spi_sync+0x0/0x98) from [<c013dcb0>] (dataflash_write+0x1b0/0=
x270)
 r8:000014bf r7:00000420 r6:c0446000 r5:00000420 r4:00a5f800
[<c013db00>] (dataflash_write+0x0/0x270) from [<c013a00c>] (part_write+0xa8=
/0xb0)
[<c0139f64>] (part_write+0x0/0xb0) from [<c00e0724>] (jffs2_flash_writev+0x=
278/0x434)
 r6:c04d9000 r5:00000420 r4:00000420
[<c00e04b0>] (jffs2_flash_writev+0x4/0x434) from [<c00e1f40>] (jffs2_sum_wr=
ite_sumnode+0x334/0x420)
[<c00e1c0c>] (jffs2_sum_write_sumnode+0x0/0x420) from [<c00d5ca0>] (jffs2_d=
o_reserve_space+0x94/0x3c8)
[<c00d5c0c>] (jffs2_do_reserve_space+0x0/0x3c8) from [<c00d6014>] (jffs2_re=
serve_space_gc+0x40/0x78)
[<c00d5fd4>] (jffs2_reserve_space_gc+0x0/0x78) from [<c00da938>] (jffs2_gar=
bage_collect_pristine+0x5c/0x3a8)
[<c00da8dc>] (jffs2_garbage_collect_pristine+0x0/0x3a8) from [<c00dc32c>] (=
jffs2_garbage_collect_pass+0x590/0x714)
[<c00dbd9c>] (jffs2_garbage_collect_pass+0x0/0x714) from [<c00dd730>] (jffs=
2_garbage_collect_thread+0x100/0x18c)
[<c00dd630>] (jffs2_garbage_collect_thread+0x0/0x18c) from [<c0039818>] (do=
_exit+0x0/0x73c)
Code: 9a000001 e15c0003 3a000001 e3a03000 (e5833000)
=0A=0A=0A      Inviato da Yahoo! Mail. =0ALa casella di posta intelligente.=
=0Ahttp://it.docs.yahoo.com/mail/overview/index.html
--0-1264241528-1207304635=:37644
Content-Type: text/x-patch; name="summary-buffer-allocation.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="summary-buffer-allocation.patch"

Q2hhbmdlIHRoZSBzdW1tYXJ5IGJ1ZmZlciBhbGxvY2F0aW9uIGZvciByZXNv
bHZpbmcgYW4gb29wcyBkdXJpbmcKZG1hIHRyYW5zZmVyIHVzaW5nIHNwaSBi
dXMuCgpTaWduZWQtb2ZmLWJ5OiBtaWNoYWVsIDx0cmltYXJjaGlAZ2FuZGFs
Zi5zc3N1cC5pdD4KCi0tLQogZnMvamZmczIvc3VtbWFyeS5jIHwgICAgNSAr
Ky0tLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvamZmczIvc3VtbWFyeS5jIGIv
ZnMvamZmczIvc3VtbWFyeS5jCmluZGV4IDYyOWFmMDEuLjU5NjJiM2IgMTAw
NjQ0Ci0tLSBhL2ZzL2pmZnMyL3N1bW1hcnkuYworKysgYi9mcy9qZmZzMi9z
dW1tYXJ5LmMKQEAgLTE3LDcgKzE3LDYgQEAKICNpbmNsdWRlIDxsaW51eC9w
YWdlbWFwLmg+CiAjaW5jbHVkZSA8bGludXgvY3JjMzIuaD4KICNpbmNsdWRl
IDxsaW51eC9jb21waWxlci5oPgotI2luY2x1ZGUgPGxpbnV4L3ZtYWxsb2Mu
aD4KICNpbmNsdWRlICJub2RlbGlzdC5oIgogI2luY2x1ZGUgImRlYnVnLmgi
CiAKQEAgLTMwLDcgKzI5LDcgQEAgaW50IGpmZnMyX3N1bV9pbml0KHN0cnVj
dCBqZmZzMl9zYl9pbmZvICpjKQogCQlyZXR1cm4gLUVOT01FTTsKIAl9CiAK
LQljLT5zdW1tYXJ5LT5zdW1fYnVmID0gdm1hbGxvYyhjLT5zZWN0b3Jfc2l6
ZSk7CisJYy0+c3VtbWFyeS0+c3VtX2J1ZiA9IGttYWxsb2MoYy0+c2VjdG9y
X3NpemUsIEdGUF9LRVJORUwpOwogCiAJaWYgKCFjLT5zdW1tYXJ5LT5zdW1f
YnVmKSB7CiAJCUpGRlMyX1dBUk5JTkcoIkNhbid0IGFsbG9jYXRlIGJ1ZmZl
ciBmb3Igd3JpdGluZyBvdXQgc3VtbWFyeSBpbmZvcm1hdGlvbiFcbiIpOwpA
QCAtNDksNyArNDgsNyBAQCB2b2lkIGpmZnMyX3N1bV9leGl0KHN0cnVjdCBq
ZmZzMl9zYl9pbmZvICpjKQogCiAJamZmczJfc3VtX2Rpc2FibGVfY29sbGVj
dGluZyhjLT5zdW1tYXJ5KTsKIAotCXZmcmVlKGMtPnN1bW1hcnktPnN1bV9i
dWYpOworCWtmcmVlKGMtPnN1bW1hcnktPnN1bV9idWYpOwogCWMtPnN1bW1h
cnktPnN1bV9idWYgPSBOVUxMOwogCiAJa2ZyZWUoYy0+c3VtbWFyeSk7Ci0t
IAoxLjUuMi4xLjE3NC5nY2QwMy1kaXJ0eQoK

--0-1264241528-1207304635=:37644--
