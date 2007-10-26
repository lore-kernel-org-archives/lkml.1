Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbXJZOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbXJZOOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXJZOOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:14:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:52169 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbXJZOOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=bVY5kZtnjkDsKNUA3TqrV7gE/RJ04nh6f8ESsp3hJMugjzMEAFDOXaMHR//XJWX2eu/mGyAD2n+bgU2kmzrsHiymOiBGMJtfYOQN9RQHsVnnz5XeXHLqjdB85YMUn2vzT+ZS8JP4V/ExZIv5mxOmPY2NyRHu71afgkYmqTaqInU=
Message-ID: <3f9a31f40710260713q4a00dd30h4f38870af8a33f14@mail.gmail.com>
Date: Fri, 26 Oct 2007 19:43:55 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Interrupt Latency test for intel machine
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_7409_9683949.1193408040735"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_7409_9683949.1193408040735
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all,

On my Intel Pentium 4 CPU 2.40 GHz machine by using attached file, I
am getting Interrupt latency as follows :-

Configuration               MAX (us)        MIN (us)        AVG (us)
     Samples
-------------                      --------             --------
      --------            -------------
PREEMPT-NONE            43.576          4.190           4.190           119343

Voluntary PREEMPT       44.414          4.190           4.190           108694

PREEMPT low-latency     39.398          4.190           5.028           112717

Thank you,

Jaswinder Singh.

------=_Part_7409_9683949.1193408040735
Content-Type: text/x-csrc; name=irq_latency.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f88rw3wr
Content-Disposition: attachment; filename=irq_latency.c

LyoKICogSW50ZXJydXB0IGxhdGVuY3kgdGVzdCBtb2R1bGUKICoKICogKEMpIDIwMDcgSmFzd2lu
ZGVyIFNpbmdoIDxqYXN3aW5kZXJsaW51eEBnbWFpbC5jb20+CiAqCiAqIFRoaXMgcHJvZ3JhbSBp
cyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IKICogbW9kaWZ5
IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2VuY2UgVmVy
c2lvbgogKiAyIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLgog
KgogKi8KCiNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4K
I2luY2x1ZGUgPGxpbnV4L2JjZC5oPgojaW5jbHVkZSA8YXNtL3RpbWUuaD4KCi8vI2RlZmluZSBE
QkdfSVJRX0xBVAkJLyogZGVidWcgaW50ZXJydXB0IGxhdGVuY3kgdGVzdCAqLwoKLyogZ2V0dGlu
ZyBnbG9iYWwgdGltZSBmcm9tIDgyNTQgKi8KI2RlZmluZSBSRUFEX0NOVDAodmFyKSBkbyB7dmFy
ID0gaW5iKDB4NDApOyB2YXIgfD0gKGluYigweDQwKSA8PCA4KTt9IHdoaWxlICgwKQoKI2lmZGVm
IERCR19JUlFfTEFUCiNkZWZpbmUgVEVTVF9DTlQJMTAwMApzdGF0aWMgbG9uZyBsYXRfdmFsW1RF
U1RfQ05UICsgMV07CnN0YXRpYyBsb25nIGxhdF92YWxfbnVtOwojZW5kaWYKCnN0YXRpYyB2b2xh
dGlsZSBsb25nIGNvdW50X2MwOwoKc3RhdGljIGxvbmcgbGF0X21heCA9IDA7CnN0YXRpYyBsb25n
IGxhdF9taW4gPSAxMDAwMDAwMDA7CnN0YXRpYyB1bnNpZ25lZCBsb25nIGlycV9jbnQgPSAwOwpz
dGF0aWMgdW5zaWduZWQgbG9uZyBsYXRfYXZnID0gMDsKCnN0YXRpYyB2b2lkIGlycV9sYXRfaGRy
KHZvaWQpCnsKCVJFQURfQ05UMChjb3VudF9jMCk7Cgljb3VudF9jMCA9IChMQVRDSCAtIGNvdW50
X2MwKTsKCWlmIChjb3VudF9jMCA+IGxhdF9tYXgpCgkJbGF0X21heCA9IGNvdW50X2MwOwoJaWYg
KGNvdW50X2MwIDwgbGF0X21pbikKCQlsYXRfbWluID0gY291bnRfYzA7CglsYXRfYXZnID0gbGF0
X2F2ZyArIGNvdW50X2MwOwoJaXJxX2NudCsrOwoKI2lmZGVmIERCR19JUlFfTEFUCglpZiAoaXJx
X2NudCA8PSBURVNUX0NOVCkKCXsKCQlsYXRfdmFsW2lycV9jbnRdID0gY291bnRfYzA7Cgl9CiNl
bmRpZgp9CgpzdGF0aWMgaW50IF9faW5pdCBpcnFfbGF0X2luaXQodm9pZCkKewoJcHJpbnRrKCIq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqXG4iKTsKCXByaW50aygiKiAgSW50
ZXJydXB0IExhdGVuY3kgbW9kdWxlIGxvYWRlZCAgKlxuIik7CglwcmludGsoIiogV2hlbiB5b3Ug
cmVtb3ZlIHRoaXMgbW9kdWxlIHlvdSAgICpcbiIpOwoJcHJpbnRrKCIqIHdpbGwgZ2V0IGludGVy
cnVwdCBsYXRlbmN5IHJlc3VsdCAqXG4iKTsKCXByaW50aygiKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKlxuIik7CgoJaXJxX2xhdF9wdHIgPSBpcnFfbGF0X2hkcjsJLyogSW5z
dGFsbCBpbnRlcnJ1cHQgaGFuZGxlciAqLwoKCXJldHVybiAwOwp9CgpzdGF0aWMgdm9pZCBfX2V4
aXQgaXJxX2xhdF9leGl0KHZvaWQpCnsKCXVuc2lnbmVkIGxvbmcgbmFub3NlY3MgPSAxMDAwMDAw
MDAwOwoKCWlycV9sYXRfcHRyID0gTlVMTDsJCS8qIFVuaW5zdGFsbCBpbnRlcnJ1cHQgaGFuZGxl
ciAqLwoKCW5hbm9zZWNzID0gKG5hbm9zZWNzL0NMT0NLX1RJQ0tfUkFURSk7CgkKCXByaW50aygi
SW50ZXJydXB0IExhdGVuY3kgcmVzdWx0XG4iKTsKCXByaW50aygiLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tXG4iKTsKCglpZiAobGF0X2F2ZykKCQlsYXRfYXZnID0gbGF0X2F2Zy9pcnFfY250OwoJ
ZWxzZQoJewoJCXByaW50aygiSW50ZXJydXB0IExhdGVuY3kgdGVzdCBGYWlsZWRcbiIpOwoJCXBy
aW50aygic2VuZCBpbmZvIHRvIDxqYXN3aW5kZXJsaW51eEBnbWFpbC5jb20+XG4iKTsKCQlyZXR1
cm47Cgl9CgojaWZkZWYgREJHX0lSUV9MQVQKCWlmIChpcnFfY250IDwgVEVTVF9DTlQpCgkJbGF0
X3ZhbF9udW0gPSBpcnFfY250OwoJZWxzZQoJCWxhdF92YWxfbnVtID0gVEVTVF9DTlQ7Cglmb3Ig
KGNvdW50X2MwID0gMTsgY291bnRfYzAgPD0gbGF0X3ZhbF9udW07IGNvdW50X2MwKyspCgl7CgkJ
cHJpbnRrKCIlNGx1OiAlNmx1ICAiLCBjb3VudF9jMCwgbGF0X3ZhbFtjb3VudF9jMF0pOwoJCWlm
ICgoY291bnRfYzAgJSA1KSA9PSAwKQoJCQlwcmludGsoIlxuIik7Cgl9CgoJcHJpbnRrKCJcbkNM
T0NLX1RJQ0tfUkFURTogJWQgVElDSzogJWx1IExBVENIOiAlZFxuIiwgQ0xPQ0tfVElDS19SQVRF
LCBuYW5vc2VjcywgTEFUQ0gpOwoJcHJpbnRrKCJNQVggbGF0ZW5jeSA6ICVsdSB0aWNrc1xuIiwg
bGF0X21heCk7CglwcmludGsoIk1JTiBsYXRlbmN5IDogJWx1IHRpY2tzXG4iLCBsYXRfbWluKTsK
CXByaW50aygiQVZHIGxhdGVuY3kgOiAlbHUgdGlja3NcbiIsIGxhdF9hdmcpOwojZW5kaWYKCXBy
aW50aygiTUFYIGxhdGVuY3kgOiAlNWx1LiUwM2x1IG1pY3JvLXNlY29uZHNcbiIsIChuYW5vc2Vj
cyAqIGxhdF9tYXgpLzEwMDAsIChuYW5vc2VjcyAqIGxhdF9tYXgpICUgMTAwMCk7CglwcmludGso
Ik1JTiBsYXRlbmN5IDogJTVsdS4lMDNsdSBtaWNyby1zZWNvbmRzXG4iLCAobmFub3NlY3MgKiBs
YXRfbWluKS8xMDAwLCAobmFub3NlY3MgKiBsYXRfbWluKSAlIDEwMDApOwoJcHJpbnRrKCJBVkcg
bGF0ZW5jeSA6ICU1bHUuJTAzbHUgbWljcm8tc2Vjb25kc1xuIiwgKG5hbm9zZWNzICogbGF0X2F2
ZykvMTAwMCwgKG5hbm9zZWNzICogbGF0X2F2ZykgJSAxMDAwKTsKCXByaW50aygiVG90YWwgU2Ft
cGxlcyA6ICVsdVxuIiwgaXJxX2NudCk7Cn0KCm1vZHVsZV9pbml0KGlycV9sYXRfaW5pdCk7Cm1v
ZHVsZV9leGl0KGlycV9sYXRfZXhpdCk7CgpNT0RVTEVfTElDRU5TRSgiR1BMIik7Cg==
------=_Part_7409_9683949.1193408040735
Content-Type: text/x-patch; name=irq_lat.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f88rwhgj
Content-Disposition: attachment; filename=irq_lat.patch

ZGlmZiAtTmF1ciBsaW51eC0yLjMuMjMtb3JnL2FyY2gvaTM4Ni9rZXJuZWwvdGltZS5jIGxpbnV4
LTIuMy4yMy9hcmNoL2kzODYva2VybmVsL3RpbWUuYwotLS0gbGludXgtMi4zLjIzLW9yZy9hcmNo
L2kzODYva2VybmVsL3RpbWUuYwkyMDA3LTEwLTI2IDE5OjE2OjM4LjAwMDAwMDAwMCArMDUzMAor
KysgbGludXgtMi4zLjIzL2FyY2gvaTM4Ni9rZXJuZWwvdGltZS5jCTIwMDctMTAtMjYgMTk6MTc6
NDkuMDAwMDAwMDAwICswNTMwCkBAIC0xNTAsNiArMTUwLDEwIEBACiB9CiBFWFBPUlRfU1lNQk9M
KHByb2ZpbGVfcGMpOwogCisvKiBJbnRlcnJ1cHQgbGF0ZW5jeSBwb2ludGVyICovCitpcnFsYXRw
dHIgaXJxX2xhdF9wdHIgPSBOVUxMOworRVhQT1JUX1NZTUJPTChpcnFfbGF0X3B0cik7CisKIC8q
CiAgKiBUaGlzIGlzIHRoZSBzYW1lIGFzIHRoZSBhYm92ZSwgZXhjZXB0IHdlIF9hbHNvXyBzYXZl
IHRoZSBjdXJyZW50CiAgKiBUaW1lIFN0YW1wIENvdW50ZXIgdmFsdWUgYXQgdGhlIHRpbWUgb2Yg
dGhlIHRpbWVyIGludGVycnVwdCwgc28gdGhhdApAQCAtMTczLDYgKzE3NywxMCBAQAogCX0KICNl
bmRpZgogCisJLyogSW50ZXJydXB0IGxhdGVuY3kgcG9pbnRlciAqLworCWlmIChpcnFfbGF0X3B0
cikKKwkJaXJxX2xhdF9wdHIoKTsKKwogCWRvX3RpbWVyX2ludGVycnVwdF9ob29rKCk7CiAKIAlp
ZiAoTUNBX2J1cykgewpkaWZmIC1OYXVyIGxpbnV4LTIuMy4yMy1vcmcvaW5jbHVkZS9hc20taTM4
Ni90aW1lLmggbGludXgtMi4zLjIzL2luY2x1ZGUvYXNtLWkzODYvdGltZS5oCi0tLSBsaW51eC0y
LjMuMjMtb3JnL2luY2x1ZGUvYXNtLWkzODYvdGltZS5oCTIwMDctMTAtMjYgMTk6MTY6MzguMDAw
MDAwMDAwICswNTMwCisrKyBsaW51eC0yLjMuMjMvaW5jbHVkZS9hc20taTM4Ni90aW1lLmgJMjAw
Ny0xMC0yNiAxOToxODoxMC4wMDAwMDAwMDAgKzA1MzAKQEAgLTI4LDYgKzI4LDEwIEBACiAJcmV0
dXJuIHJldHZhbDsKIH0KIAorLyogaW50ZXJydXB0IGxhdGVuY3kgcG9pbnRlciAqLwordHlwZWRl
ZiB2b2lkICgqaXJxbGF0cHRyKSh2b2lkKTsKK2V4dGVybiBpcnFsYXRwdHIgaXJxX2xhdF9wdHI7
CisKIGV4dGVybiB2b2lkICgqbGF0ZV90aW1lX2luaXQpKHZvaWQpOwogZXh0ZXJuIHZvaWQgaHBl
dF90aW1lX2luaXQodm9pZCk7CiAK
------=_Part_7409_9683949.1193408040735
Content-Type: application/octet-stream; name=Makefile
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f88rwmso
Content-Disposition: attachment; filename=Makefile

b2JqLW5hbWUgOj0gaXJxX2xhdGVuY3kKb2JqLW0gOj0gJChvYmotbmFtZSkubwoKS0RJUiA6PSAk
KEhPTUUpL2xpbnV4LSQoc2hlbGwgdW5hbWUgLXIpCgpQV0QgOj0gJChzaGVsbCBwd2QpCgpkZWZh
dWx0OgoJJChNQUtFKSAtQyAkKEtESVIpIFNVQkRJUlM9JChQV0QpIG1vZHVsZXMKCmNsZWFuOgoJ
cm0gLXJmICoua28gKi5vICoubW9kLmMgLiouY21kIE1vZCogLiQob2JqLW5hbWUpKiAudG1wX3Zl
cnNpb25zCg==
------=_Part_7409_9683949.1193408040735--
