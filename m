Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYKZXMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYKZXMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbYKZXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:12:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:40981 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755210AbYKZXMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:12:15 -0500
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="========GMX27107122774113395997"
Date: Thu, 27 Nov 2008 00:12:13 +0100
From: "Carsten Menke" <bootsy52@gmx.net>
Message-ID: <20081126231213.271070@gmx.net>
MIME-Version: 1.0
Subject: Panic:  NMI Watchdog detected LOCKUP on CPU
To: linux-kernel@vger.kernel.org
X-Authenticated: #1189245
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18B0jRd0EcB7mOM0/UthQK+zaA+bdaWXEbuZHp+0x
 6cSaA5WQsZUbcGYvm0dTuDIZ+lyr2x3p2mtQ== 
X-GMX-UID: ++IfcdRaPjl+EEgRJDU2JVI7MTE2NYlR
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX27107122774113395997
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi List,

I hope this is not the too wrong place to ask a question about the issue in the subject as the problem arises with a rather old 2.6.15 Kernel of an Ubuntu 6.06 Installation. But as nobody has even looked at the report I filed in the Ubuntu Bug database for 2  months. I try my luck here. I got a HP ML 350 G5 Server running and I occasionly receive kernel panics (vary from 1 time per week up to 2 months). I just want to get any pointer if this may be a hardware issue or a kernel issue, which in turn may have been fixed in a later version. As only Red Hat is supported by HP it will get rather difficult to get someone on service (we have an extended On site Warranty) an replace parts as we're running Ubuntu on the server and 2nd the diagnostic CD (Smart Start) shows that everything is ok (That of course doesn't mean, i trust these tools to much).

One thing I noted is that always the smbd process occurs in the panic log, the second thing is that it seems that it is unrelated to the system load as it happened 1 time during full working hours and another time during the night whe the server was absolutly idle (The server in turn does not do much more than a load of 20% either).

So here is the log I caputred via syslogd from netconsole and the dmesg, please apologize that due to syslog some lines are split across multiple lines, which show actually up as one on the console

Hope someone get me anywhere

Carsten

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX27107122774113395997
Content-Type: application/octet-stream; name="syslog.mail.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="syslog.mail.log"

U2VwIDMwIDIzOjQyOjQ1IG1haWwgWzQzMDY4Mi4xNDE4MTBdIFVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIHBhZ2luZyByZXF1ZXN0ClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBhdCAwMDAwMDAwMDAwMTAw
MTA4IFJJUDogIApTZXAgMzAgMjM6NDI6NDUgbWFpbCBbNDMwNjgyLjE0NDEyNV0gClNlcCAzMCAy
Mzo0Mjo0NSBtYWlsIGZmZmZmZmZmODAxNDc5NjU+e2ZyZWVfdWlkKzM3fQpTZXAgMzAgMjM6NDI6
NDUgbWFpbCAgClNlcCAzMCAyMzo0Mjo0NSBtYWlsIFs0MzA2ODIuMTY1MTA3XSBQR0QgMCAKU2Vw
IDMwIDIzOjQyOjQ1IG1haWwgIApTZXAgMzAgMjM6NDI6NDUgbWFpbCBbNDMwNjgyLjE3NDgyNV0g
T29wczogMDAwMiBbMl0gClNlcCAzMCAyMzo0Mjo0NSBtYWlsIFNNUCAKU2VwIDMwIDIzOjQyOjQ1
IG1haWwgIApTZXAgMzAgMjM6NDI6NDUgbWFpbCBbNDMwNjgyLjE4NDk0Ml0gQ1BVIDIgClNlcCAz
MCAyMzo0Mjo0NSBtYWlsICAKU2VwIDMwIDIzOjQyOjQ1IG1haWwgWzQzMDY4Mi4xOTQzMDJdIE1v
ZHVsZXMgbGlua2VkIGluOgpTZXAgMzAgMjM6NDI6NDUgbWFpbCAgbmV0Y29uc29sZQpTZXAgMzAg
MjM6NDI6NDUgbWFpbCAgdHVuClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBpcHY2ClNlcCAzMCAyMzo0
Mjo0NSBtYWlsICBleHQzClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBqYmQKU2VwIDMwIDIzOjQyOjQ1
IG1haWwgIGRtX21vZApTZXAgMzAgMjM6NDI6NDUgbWFpbCAgbWRfbW9kClNlcCAzMCAyMzo0Mjo0
NSBtYWlsICBwYXJwb3J0X3BjClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBscApTZXAgMzAgMjM6NDI6
NDUgbWFpbCAgcGFycG9ydApTZXAgMzAgMjM6NDI6NDUgbWFpbCAgYm54MgpTZXAgMzAgMjM6NDI6
NDUgbWFpbCAgaHdfcmFuZG9tClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBwY3Nwa3IKU2VwIDMwIDIz
OjQyOjQ1IG1haWwgIHBzbW91c2UKU2VwIDMwIDIzOjQyOjQ1IG1haWwgIHNlcmlvX3JhdwpTZXAg
MzAgMjM6NDI6NDUgbWFpbCAgc2hwY2hwClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBwY2lfaG90cGx1
ZwpTZXAgMzAgMjM6NDI6NDUgbWFpbCAgc2cKU2VwIDMwIDIzOjQyOjQ1IG1haWwgIHN0ClNlcCAz
MCAyMzo0Mjo0NSBtYWlsICB0c2RldgpTZXAgMzAgMjM6NDI6NDUgbWFpbCAgZXZkZXYKU2VwIDMw
IDIzOjQyOjQ1IG1haWwgIHhmcwpTZXAgMzAgMjM6NDI6NDUgbWFpbCAgZXhwb3J0ZnMKU2VwIDMw
IDIzOjQyOjQ1IG1haWwgIHVzYmhpZApTZXAgMzAgMjM6NDI6NDUgbWFpbCAgaWRlX2dlbmVyaWMK
U2VwIDMwIDIzOjQyOjQ1IG1haWwgIGVoY2lfaGNkClNlcCAzMCAyMzo0Mjo0NSBtYWlsICB1aGNp
X2hjZApTZXAgMzAgMjM6NDI6NDUgbWFpbCAgdXNiY29yZQpTZXAgMzAgMjM6NDI6NDUgbWFpbCAg
aWRlX2NkClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBjZHJvbQpTZXAgMzAgMjM6NDI6NDUgbWFpbCAg
cGlpeApTZXAgMzAgMjM6NDI6NDUgbWFpbCAgZ2VuZXJpYwpTZXAgMzAgMjM6NDI6NDUgbWFpbCAg
Y2Npc3MKU2VwIDMwIDIzOjQyOjQ1IG1haWwgIG1wdHNwaQpTZXAgMzAgMjM6NDI6NDUgbWFpbCAg
bXB0c2NzaWgKU2VwIDMwIDIzOjQyOjQ1IG1haWwgIG1wdGJhc2UKU2VwIDMwIDIzOjQyOjQ1IG1h
aWwgIHNjc2lfbW9kClNlcCAzMCAyMzo0Mjo0NSBtYWlsICB0aGVybWFsClNlcCAzMCAyMzo0Mjo0
NSBtYWlsICBwcm9jZXNzb3IKU2VwIDMwIDIzOjQyOjQ1IG1haWwgIGZhbgpTZXAgMzAgMjM6NDI6
NDUgbWFpbCAgY2FwYWJpbGl0eQpTZXAgMzAgMjM6NDI6NDUgbWFpbCAgY29tbW9uY2FwClNlcCAz
MCAyMzo0Mjo0NSBtYWlsICB2Z2ExNmZiClNlcCAzMCAyMzo0Mjo0NSBtYWlsICBjZmJjb3B5YXJl
YQpTZXAgMzAgMjM6NDI6NDUgbWFpbCAgdmdhc3RhdGUKU2VwIDMwIDIzOjQyOjQ1IG1haWwgIGNm
YmltZ2JsdApTZXAgMzAgMjM6NDI6NDUgbWFpbCAgY2ZiZmlsbHJlY3QKU2VwIDMwIDIzOjQyOjQ1
IG1haWwgIGZiY29uClNlcCAzMCAyMzo0Mjo0NSBtYWlsICB0aWxlYmxpdApTZXAgMzAgMjM6NDI6
NDUgbWFpbCAgZm9udApTZXAgMzAgMjM6NDI6NDUgbWFpbCAgYml0YmxpdApTZXAgMzAgMjM6NDI6
NDUgbWFpbCAgc29mdGN1cnNvcgpTZXAgMzAgMjM6NDI6NDUgbWFpbCAgClNlcCAzMCAyMzo0Mjo0
NSBtYWlsIFs0MzA2ODIuMjYzMjExXSBQaWQ6IDIxNjc5LCBjb21tOiBzbWJkIE5vdCB0YWludGVk
IDIuNi4xNS01Mi1hbWQ2NC1zZXJ2ZXIgIzEgClNlcCAzMCAyMzo0Mjo0NSBtYWlsIFs0MzA2ODIu
Mjc0NDkzXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgwMTQ3OTY1Pl0gClNlcCAzMCAyMzo0Mjo0NSBt
YWlsIGZmZmZmZmZmODAxNDc5NjU+e2ZyZWVfdWlkKzM3fQpTZXAgMzAgMjM6NDI6NDUgbWFpbCAg
ClNlcCAzMCAyMzo0Mjo0NSBtYWlsIFs0MzA2ODIuMjc3MTM5XSBSU1A6IDAwMTg6ZmZmZjgxMDEw
MWY0ZmQ4OCAgRUZMQUdTOiAwMDAxMDAwMiAKU2VwIDMwIDIzOjQyOjQ1IG1haWwgWzQzMDY4Mi4y
OTYxOTldIFJBWDogMDAwMDAwMDAwMDIwMDIwMCBSQlg6IGZmZmY4MTAwNDQxN2Y5YzAgUkNYOiBm
ZmZmODEwMDQ0MTdmOWY4IApTZXAgMzAgMjM6NDI6NDUgbWFpbCBbNDMwNjgyLjMxNjE1MV0gUkRY
OiAwMDAwMDAwMDAwMTAwMTAwIFJTSTogZmZmZmZmZmY4MDM3NmI5MCBSREk6IGZmZmZmZmZmODAz
NzZiOTAgClNlcCAzMCAyMzo0Mjo0NSBtYWlsIFs0MzA2ODIuMzM3NDI1XSBSQlA6IGZmZmY4MTAx
MWZiYTczMjggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDBmZmZmZmZmZiAKU2Vw
IDMwIDIzOjQyOjQ1IG1haWwgWzQzMDY4Mi4zNTc2NjRdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBS
MTE6IDAwMDAwMDAwMDAwMDAyNDYgUjEyOiAwMDAwMDAwMDAwMDAwMDAwIApTZXAgMzAgMjM6NDI6
NDUgbWFpbCBbNDMwNjgyLjM3NzgxN10gUjEzOiBmZmZmODEwMTAxZjRmZTc4IFIxNDogMDAwMDAw
MDAwMDAwMDAwYSBSMTU6IDAwMDAwMDAwMDAwMDAwMDkgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIFs0
MzA2ODIuMzk4NzkwXSBGUzogIDAwMDAyYWFhYWM5NmJmMTAoMDAwMCkgR1M6ZmZmZmZmZmY4MDQ1
MzkwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwIApTZXAgMzAgMjM6NDI6NDYgbWFpbCBb
NDMwNjgyLjQxOTg0Nl0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4
MDA1MDAzYiAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgWzQzMDY4Mi40MzEzODVdIENSMjogMDAwMDAw
MDAwMDEwMDEwOCBDUjM6IDAwMDAwMDAxMWY5YmIwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmUwIApT
ZXAgMzAgMjM6NDI6NDYgbWFpbCBbNDMwNjgyLjQ1MzI5M10gUHJvY2VzcyBzbWJkIChwaWQ6IDIx
Njc5LCB0aHJlYWRpbmZvIGZmZmY4MTAxMDFmNGUwMDAsIHRhc2sgZmZmZjgxMDExZmFjYjFlMCkg
ClNlcCAzMCAyMzo0Mjo0NiBtYWlsIFs0MzA2ODIuNDc1Nzk5XSBTdGFjazogClNlcCAzMCAyMzo0
Mjo0NiBtYWlsIGZmZmY4MTAxMTdiYWZiZDAgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIGZmZmZmZmZm
ODAxNDk4MzggClNlcCAzMCAyMzo0Mjo0NiBtYWlsIGZmZmY4MTAxMDFmNGZkYzggClNlcCAzMCAy
Mzo0Mjo0NiBtYWlsIDAwMDAwMDAwMDAwMDAwMDAgClNlcCAzMCAyMzo0Mjo0NiBtYWlsICAKU2Vw
IDMwIDIzOjQyOjQ2IG1haWwgWzQzMDY4Mi40ODg5NjJdICAgICAgICAKU2VwIDMwIDIzOjQyOjQ2
IG1haWwgZmZmZjgxMDEwMWY0ZmU3OCAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgZmZmZjgxMDExZmFj
YjdiOCAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgZmZmZjgxMDExZmFjYjFlMCAKU2VwIDMwIDIzOjQy
OjQ2IG1haWwgMDAwMDAwMDAwMDAwMDAwMCAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgIApTZXAgMzAg
MjM6NDI6NDYgbWFpbCBbNDMwNjgyLjUxMTk5MF0gICAgICAgIApTZXAgMzAgMjM6NDI6NDYgbWFp
bCBmZmZmODEwMTAxZjRmZTc4IApTZXAgMzAgMjM6NDI6NDYgbWFpbCBmZmZmZmZmZjgwMTQ5OTE5
IApTZXAgMzAgMjM6NDI6NDYgbWFpbCAgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIFs0MzA2ODIuNTI0
MDAzXSBDYWxsIFRyYWNlOgpTZXAgMzAgMjM6NDI6NDYgbWFpbCBmZmZmZmZmZjgwMTQ5ODM4Pntf
X2RlcXVldWVfc2lnbmFsKzQyNH0KU2VwIDMwIDIzOjQyOjQ2IG1haWwgIApTZXAgMzAgMjM6NDI6
NDYgbWFpbCBmZmZmZmZmZjgwMTQ5OTE5PntkZXF1ZXVlX3NpZ25hbCs3M30KU2VwIDMwIDIzOjQy
OjQ2IG1haWwgIApTZXAgMzAgMjM6NDI6NDYgbWFpbCBbNDMwNjgyLjU0NzQ2MV0gICAgICAgIApT
ZXAgMzAgMjM6NDI6NDYgbWFpbCBmZmZmZmZmZjgwMTRhYTc2PntnZXRfc2lnbmFsX3RvX2RlbGl2
ZXIrMzU4fQpTZXAgMzAgMjM6NDI6NDYgbWFpbCAgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIGZmZmZm
ZmZmODAxMGY0NmQ+e2RvX3NpZ25hbCsxNTd9ClNlcCAzMCAyMzo0Mjo0NiBtYWlsICAKU2VwIDMw
IDIzOjQyOjQ2IG1haWwgWzQzMDY4Mi41NzAzNjhdICAgICAgICAKU2VwIDMwIDIzOjQyOjQ2IG1h
aWwgZmZmZmZmZmY4MDEwZmUwYj57c3lzcmV0X3NpZ25hbCsyOH0KU2VwIDMwIDIzOjQyOjQ2IG1h
aWwgIApTZXAgMzAgMjM6NDI6NDYgbWFpbCBmZmZmZmZmZjgwMTEwMGYzPntwdHJlZ3NjYWxsX2Nv
bW1vbisxMDN9ClNlcCAzMCAyMzo0Mjo0NiBtYWlsICAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgWzQz
MDY4Mi41OTI5MjFdICAgICAgICAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgIApTZXAgMzAgMjM6NDI6
NDYgbWFpbCBbNDMwNjgyLjYxMTkwOF0gIApTZXAgMzAgMjM6NDI6NDYgbWFpbCBbNDMwNjgyLjYx
MTkwOV0gQ29kZTogClNlcCAzMCAyMzo0Mjo0NiBtYWlsIDQ4IApTZXAgMzAgMjM6NDI6NDYgbWFp
bCA4OSAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgNDIgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIDA4IApT
ZXAgMzAgMjM6NDI6NDYgbWFpbCA0OCAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgODkgClNlcCAzMCAy
Mzo0Mjo0NiBtYWlsIDEwIApTZXAgMzAgMjM6NDI6NDYgbWFpbCA0OCAKU2VwIDMwIDIzOjQyOjQ2
IG1haWwgYzcgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIDQxIApTZXAgMzAgMjM6NDI6NDYgbWFpbCAw
OCAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgMDAgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIDAyIApTZXAg
MzAgMjM6NDI6NDYgbWFpbCAyMCAKU2VwIDMwIDIzOjQyOjQ2IG1haWwgMDAgClNlcCAzMCAyMzo0
Mjo0NiBtYWlsIDQ4IApTZXAgMzAgMjM6NDI6NDYgbWFpbCA4YiAKU2VwIDMwIDIzOjQyOjQ2IG1h
aWwgN2IgClNlcCAzMCAyMzo0Mjo0NiBtYWlsIDI4IApTZXAgMzAgMjM6NDI6NDYgbWFpbCA0OCAK
U2VwIDMwIDIzOjQyOjQ2IG1haWwgIApTZXAgMzAgMjM6NDI6NDYgbWFpbCBbNDMwNjgyLjY0Mzg0
M10gUklQIApTZXAgMzAgMjM6NDI6NDYgbWFpbCBmZmZmZmZmZjgwMTQ3OTY1PntmcmVlX3VpZCsz
N30KU2VwIDMwIDIzOjQyOjQ2IG1haWwgIFJTUCA8ZmZmZjgxMDEwMWY0ZmQ4OD4gClNlcCAzMCAy
Mzo0Mjo0NiBtYWlsIFs0MzA2ODIuNjU1OTYwXSBDUjI6IDAwMDAwMDAwMDAxMDAxMDggClNlcCAz
MCAyMzo0Mjo0NiBtYWlsIFs0MzA2ODIuNjcyNzU1XSAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIE5N
SSBXYXRjaGRvZyBkZXRlY3RlZCBMT0NLVVAgb24gQ1BVIDIgClNlcCAzMCAyMzo0Mjo1MSBtYWls
IFs0MzA2ODcuNjc3MzA0XSBDUFUgMiAKU2VwIDMwIDIzOjQyOjUxIG1haWwgIApTZXAgMzAgMjM6
NDI6NTEgbWFpbCBbNDMwNjg3LjY4NzM3Ml0gTW9kdWxlcyBsaW5rZWQgaW46ClNlcCAzMCAyMzo0
Mjo1MSBtYWlsICBuZXRjb25zb2xlClNlcCAzMCAyMzo0Mjo1MSBtYWlsICB0dW4KU2VwIDMwIDIz
OjQyOjUxIG1haWwgIGlwdjYKU2VwIDMwIDIzOjQyOjUxIG1haWwgIGV4dDMKU2VwIDMwIDIzOjQy
OjUxIG1haWwgIGpiZApTZXAgMzAgMjM6NDI6NTEgbWFpbCAgZG1fbW9kClNlcCAzMCAyMzo0Mjo1
MSBtYWlsICBtZF9tb2QKU2VwIDMwIDIzOjQyOjUxIG1haWwgIHBhcnBvcnRfcGMKU2VwIDMwIDIz
OjQyOjUxIG1haWwgIGxwClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBwYXJwb3J0ClNlcCAzMCAyMzo0
Mjo1MSBtYWlsICBibngyClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBod19yYW5kb20KU2VwIDMwIDIz
OjQyOjUxIG1haWwgIHBjc3BrcgpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgcHNtb3VzZQpTZXAgMzAg
MjM6NDI6NTEgbWFpbCAgc2VyaW9fcmF3ClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBzaHBjaHAKU2Vw
IDMwIDIzOjQyOjUxIG1haWwgIHBjaV9ob3RwbHVnClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBzZwpT
ZXAgMzAgMjM6NDI6NTEgbWFpbCAgc3QKU2VwIDMwIDIzOjQyOjUxIG1haWwgIHRzZGV2ClNlcCAz
MCAyMzo0Mjo1MSBtYWlsICBldmRldgpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgeGZzClNlcCAzMCAy
Mzo0Mjo1MSBtYWlsICBleHBvcnRmcwpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgdXNiaGlkClNlcCAz
MCAyMzo0Mjo1MSBtYWlsICBpZGVfZ2VuZXJpYwpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgZWhjaV9o
Y2QKU2VwIDMwIDIzOjQyOjUxIG1haWwgIHVoY2lfaGNkClNlcCAzMCAyMzo0Mjo1MSBtYWlsICB1
c2Jjb3JlClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBpZGVfY2QKU2VwIDMwIDIzOjQyOjUxIG1haWwg
IGNkcm9tClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBwaWl4ClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBn
ZW5lcmljClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBjY2lzcwpTZXAgMzAgMjM6NDI6NTEgbWFpbCAg
bXB0c3BpClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBtcHRzY3NpaApTZXAgMzAgMjM6NDI6NTEgbWFp
bCAgbXB0YmFzZQpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgc2NzaV9tb2QKU2VwIDMwIDIzOjQyOjUx
IG1haWwgIHRoZXJtYWwKU2VwIDMwIDIzOjQyOjUxIG1haWwgIHByb2Nlc3NvcgpTZXAgMzAgMjM6
NDI6NTEgbWFpbCAgZmFuClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBjYXBhYmlsaXR5ClNlcCAzMCAy
Mzo0Mjo1MSBtYWlsICBjb21tb25jYXAKU2VwIDMwIDIzOjQyOjUxIG1haWwgIHZnYTE2ZmIKU2Vw
IDMwIDIzOjQyOjUxIG1haWwgIGNmYmNvcHlhcmVhClNlcCAzMCAyMzo0Mjo1MSBtYWlsICB2Z2Fz
dGF0ZQpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgY2ZiaW1nYmx0ClNlcCAzMCAyMzo0Mjo1MSBtYWls
ICBjZmJmaWxscmVjdApTZXAgMzAgMjM6NDI6NTEgbWFpbCAgZmJjb24KU2VwIDMwIDIzOjQyOjUx
IG1haWwgIHRpbGVibGl0ClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBmb250ClNlcCAzMCAyMzo0Mjo1
MSBtYWlsICBiaXRibGl0ClNlcCAzMCAyMzo0Mjo1MSBtYWlsICBzb2Z0Y3Vyc29yClNlcCAzMCAy
Mzo0Mjo1MSBtYWlsICAKU2VwIDMwIDIzOjQyOjUxIG1haWwgWzQzMDY4Ny43NjE3NDFdIFBpZDog
NjA3MCwgY29tbTogc21iZCBOb3QgdGFpbnRlZCAyLjYuMTUtNTItYW1kNjQtc2VydmVyICMxIApT
ZXAgMzAgMjM6NDI6NTEgbWFpbCBbNDMwNjg3Ljc3MzIwM10gUklQOiAwMDEwOls8ZmZmZmZmZmY4
MDMwZTZiYj5dIApTZXAgMzAgMjM6NDI6NTEgbWFpbCBmZmZmZmZmZjgwMzBlNmJiPnsudGV4dC5s
b2NrLnNwaW5sb2NrKzJ9ClNlcCAzMCAyMzo0Mjo1MSBtYWlsICAKU2VwIDMwIDIzOjQyOjUxIG1h
aWwgWzQzMDY4Ny43ODU1MDJdIFJTUDogMDAxODpmZmZmODEwMDRkMmZmZTgwICBFRkxBR1M6IDAw
MDAwMDg2IApTZXAgMzAgMjM6NDI6NTEgbWFpbCBbNDMwNjg3LjgwNTU1MV0gUkFYOiAwMDAwMDAw
MDAwMDAwMDAxIFJCWDogZmZmZjgxMDExZmJhNzMwMCBSQ1g6IGZmZmY4MTAwMjAzMGY2MTAgClNl
cCAzMCAyMzo0Mjo1MSBtYWlsIFs0MzA2ODcuODI2MjA0XSBSRFg6IGZmZmY4MTAwMDRmZDVhYjAg
UlNJOiAwMDAwMDAwMDAwMDAwMDA5IFJESTogZmZmZjgxMDExZjQyMTU4OCAKU2VwIDMwIDIzOjQy
OjUxIG1haWwgWzQzMDY4Ny44NDc1NDBdIFJCUDogZmZmZjgxMDExZmFjYjFlMCBSMDg6IDAwMDAw
MDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwIApTZXAgMzAgMjM6NDI6NTEgbWFpbCBb
NDMwNjg3Ljg2OTE3MV0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDI0
NiBSMTI6IGZmZmY4MTAxMWY0MjBkODAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIFs0MzA2ODcuODkx
ODQ3XSBSMTM6IGZmZmY4MTAwMjAzMGY1ZjggUjE0OiBmZmZmODEwMTFkOGZlMzAwIFIxNTogMDAw
MDAwMDAwMDAwMDAwMSAKU2VwIDMwIDIzOjQyOjUxIG1haWwgWzQzMDY4Ny45MTM3NjVdIEZTOiAg
MDAwMDJhYWFhYzk2YmYxMCgwMDAwKSBHUzpmZmZmZmZmZjgwNDUzOTAwKDAwMDApIGtubEdTOjAw
MDAwMDAwMDAwMDAwMDAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIFs0MzA2ODcuOTM1ODIyXSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiIApTZXAgMzAgMjM6
NDI6NTEgbWFpbCBbNDMwNjg3Ljk0NzU3N10gQ1IyOiAwMDAwMDAwMDAwMTAwMTA4IENSMzogMDAw
MDAwMDA0ODFhOTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZTAgClNlcCAzMCAyMzo0Mjo1MSBtYWls
IFs0MzA2ODcuOTY5NDE3XSBQcm9jZXNzIHNtYmQgKHBpZDogNjA3MCwgdGhyZWFkaW5mbyBmZmZm
ODEwMDRkMmZlMDAwLCB0YXNrIGZmZmY4MTAxMWQ4ZmUzMDApIApTZXAgMzAgMjM6NDI6NTEgbWFp
bCBbNDMwNjg3Ljk5MjA4MF0gU3RhY2s6IApTZXAgMzAgMjM6NDI6NTEgbWFpbCBmZmZmZmZmZjgw
MTQ5NDkxIApTZXAgMzAgMjM6NDI6NTEgbWFpbCBmZmZmODEwMTFmYWNiMWUwIApTZXAgMzAgMjM6
NDI6NTEgbWFpbCBmZmZmODEwMTFmYWNiMWUwIApTZXAgMzAgMjM6NDI6NTEgbWFpbCAwMDAwMDAw
MDAwMDA1NGFmIApTZXAgMzAgMjM6NDI6NTEgbWFpbCAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIFs0
MzA2ODguMDA1NjQxXSAgICAgICAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIGZmZmZmZmZmODAxM2Yw
OWEgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIDAwMDAwMDAwMDAwMDAyNDYgClNlcCAzMCAyMzo0Mjo1
MSBtYWlsIGZmZmY4MTAxMWZhY2IzMTAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIGZmZmY4MTAxMWZh
Y2IxZTAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsICAKU2VwIDMwIDIzOjQyOjUxIG1haWwgWzQzMDY4
OC4wMjg3NzJdICAgICAgICAKU2VwIDMwIDIzOjQyOjUxIG1haWwgMDAwMDAwMDAwMDAwNTRhZiAK
U2VwIDMwIDIzOjQyOjUxIG1haWwgMDAwMDAwMDAwMDAwMDAwNSAKU2VwIDMwIDIzOjQyOjUxIG1h
aWwgIApTZXAgMzAgMjM6NDI6NTEgbWFpbCBbNDMwNjg4LjA0MDgyN10gQ2FsbCBUcmFjZToKU2Vw
IDMwIDIzOjQyOjUxIG1haWwgZmZmZmZmZmY4MDE0OTQ5MT57X19leGl0X3NpZ25hbCs2NX0KU2Vw
IDMwIDIzOjQyOjUxIG1haWwgIApTZXAgMzAgMjM6NDI6NTEgbWFpbCBmZmZmZmZmZjgwMTNmMDlh
PntyZWxlYXNlX3Rhc2srMTM4fQpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgClNlcCAzMCAyMzo0Mjo1
MSBtYWlsIFs0MzA2ODguMDY0MTc2XSAgICAgICAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIGZmZmZm
ZmZmODAxNDBjOGY+e2RvX3dhaXQrMjA5NX0KU2VwIDMwIDIzOjQyOjUxIG1haWwgIApTZXAgMzAg
MjM6NDI6NTEgbWFpbCBmZmZmZmZmZjgwMThlNGFmPnt2ZnNfd3JpdGUrMzM1fQpTZXAgMzAgMjM6
NDI6NTEgbWFpbCAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIFs0MzA2ODguMDg2ODYzXSAgICAgICAg
ClNlcCAzMCAyMzo0Mjo1MSBtYWlsIGZmZmZmZmZmODAxMzg0NjA+e2RlZmF1bHRfd2FrZV9mdW5j
dGlvbiswfQpTZXAgMzAgMjM6NDI6NTEgbWFpbCAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIGZmZmZm
ZmZmODAxMGZkODI+e3N5c3RlbV9jYWxsKzEyNn0KU2VwIDMwIDIzOjQyOjUxIG1haWwgIApTZXAg
MzAgMjM6NDI6NTEgbWFpbCBbNDMwNjg4LjEwOTM1OF0gICAgICAgIApTZXAgMzAgMjM6NDI6NTEg
bWFpbCAgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIFs0MzA2ODguMTI4NDE0XSAgClNlcCAzMCAyMzo0
Mjo1MSBtYWlsIFs0MzA2ODguMTI4NDE1XSBDb2RlOiAKU2VwIDMwIDIzOjQyOjUxIG1haWwgODMg
ClNlcCAzMCAyMzo0Mjo1MSBtYWlsIDNmIApTZXAgMzAgMjM6NDI6NTEgbWFpbCAwMCAKU2VwIDMw
IDIzOjQyOjUxIG1haWwgN2UgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIGY5IApTZXAgMzAgMjM6NDI6
NTEgbWFpbCBlOSAKU2VwIDMwIDIzOjQyOjUxIG1haWwgM2IgClNlcCAzMCAyMzo0Mjo1MSBtYWls
IGZkIApTZXAgMzAgMjM6NDI6NTEgbWFpbCBmZiAKU2VwIDMwIDIzOjQyOjUxIG1haWwgZmYgClNl
cCAzMCAyMzo0Mjo1MSBtYWlsIGU4IApTZXAgMzAgMjM6NDI6NTEgbWFpbCBiYSAKU2VwIDMwIDIz
OjQyOjUxIG1haWwgMTYgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIGYwIApTZXAgMzAgMjM6NDI6NTEg
bWFpbCBmZiAKU2VwIDMwIDIzOjQyOjUxIG1haWwgZTkgClNlcCAzMCAyMzo0Mjo1MSBtYWlsIDkx
IApTZXAgMzAgMjM6NDI6NTEgbWFpbCBmZCAKU2VwIDMwIDIzOjQyOjUxIG1haWwgZmYgClNlcCAz
MCAyMzo0Mjo1MSBtYWlsIGZmIApTZXAgMzAgMjM6NDI6NTEgbWFpbCAgClNlcCAzMCAyMzo0Mjo1
MSBtYWlsIFs0MzA2ODguMTYwNzU2XSBjb25zb2xlIHNodXRzIHVwIC4uLiAKU2VwIDMwIDIzOjQy
OjUxIG1haWwgWzQzMDY4OC4xNzEyMjddICAKU2VwIDMwIDIzOjQyOjUxIG1haWwgS2VybmVsIHBh
bmljIC0gbm90IHN5bmNpbmc6IEFpZWUsIGtpbGxpbmcgaW50ZXJydXB0IGhhbmRsZXIhIApTZXAg
MzAgMjM6NDI6NTEgbWFpbCBbNDMwNjg4LjE4MzM1Ml0gIAo=
--========GMX27107122774113395997
Content-Type: text/plain; charset="iso-8859-15"; name="dmesg.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Bootdata ok (command line is root=/dev/cciss/c0d0p5 ro console=ttyS1 console=tty0 quiet splash)
[    0.000000] Linux version 2.6.15-52-amd64-server (buildd@king) (gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #1 SMP Wed Aug 20 13:36:39 UTC 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfe54000 (usable)
[    0.000000]  BIOS-e820: 00000000dfe54000 - 00000000dfe5c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfe5c000 - 00000000dfe5d000 (usable)
[    0.000000]  BIOS-e820: 00000000dfe5d000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011ffff000 (usable)
[    0.000000] ACPI: RSDP (v002 HP                                    ) @ 0x00000000000f4f00
[    0.000000] ACPI: XSDT (v001 HP     ProLiant 0x00000002 Ò 0x0000162e) @ 0x00000000dfe547c0
[    0.000000] ACPI: FADT (v003 HP     ProLiant 0x00000002 Ò 0x0000162e) @ 0x00000000dfe54840
[    0.000000] ACPI: SPCR (v001 HP     SPCRRBSU 0x00000001 Ò 0x0000162e) @ 0x00000000dfe54140
[    0.000000] ACPI: MCFG (v001 HP     ProLiant 0x00000001  0x00000000) @ 0x00000000dfe541c0
[    0.000000] ACPI: HPET (v001 HP     ProLiant 0x00000002 Ò 0x0000162e) @ 0x00000000dfe54200
[    0.000000] ACPI: SPMI (v005 HP     ProLiant 0x00000001 Ò 0x0000162e) @ 0x00000000dfe54240
[    0.000000] ACPI: ERST (v001 HP     ProLiant 0x00000001 Ò 0x0000162e) @ 0x00000000dfe54280
[    0.000000] ACPI: MADT (v001 HP     ProLiant 0x00000002  0x00000000) @ 0x00000000dfe54480
[    0.000000] ACPI: FFFF (v001 HP     ProLiant 0x00000001 Ò 0x0000162e) @ 0x00000000dfe54540
[    0.000000] ACPI: BERT (v001 HP     ProLiant 0x00000001 Ò 0x0000162e) @ 0x00000000dfe546c0
[    0.000000] ACPI: HEST (v001 HP     ProLiant 0x00000001 Ò 0x0000162e) @ 0x00000000dfe54700
[    0.000000] ACPI: SSDT (v001 HP        SSDTP 0x00000001 INTL 0x20061109) @ 0x00000000dfe59000
[    0.000000] ACPI: DSDT (v001 HP         DSDT 0x00000001 INTL 0x20061109) @ 0x0000000000000000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000011ffff000
[    0.000000] Bootmem setup node 0 0000000000000000-000000011ffff000
[    0.000000] On node 0 totalpages: 1030978
[    0.000000]   DMA zone: 2997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 898701 pages, LIFO batch:31
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages, LIFO batch:0
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] Processor #6 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] Processor #7 6:15 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to physical flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
[    0.000000] Checking aperture...
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] Built 1 zonelists
[    0.000000] Kernel command line: root=/dev/cciss/c0d0p5 ro console=ttyS1 console=tty0 quiet splash
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 131072 bytes)
[    0.000000] time.c: Using 14.318180 MHz HPET timer.
[    0.000000] time.c: Detected 2333.420 MHz processor.
[   82.838254] Console: colour VGA+ 80x25
[   82.840116] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   82.842153] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   82.842437] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   82.872444] Placing software IO TLB between 0x5580000 - 0x9580000
[   82.904749] Memory: 4044144k/4718588k available (2116k kernel code, 148060k reserved, 807k data, 180k init)
[   82.984676] Calibrating delay using timer specific routine.. 4671.05 BogoMIPS (lpj=9342101)
[   82.984720] Security Framework v1.0.0 initialized
[   82.984725] SELinux:  Disabled at boot.
[   82.984751] Mount-cache hash table entries: 256
[   82.984860] CPU: L1 I cache: 32K, L1 D cache: 32K
[   82.984862] CPU: L2 cache: 4096K
[   82.984864] using mwait in idle threads.
[   82.984866] CPU: Physical Processor ID: 0
[   82.984867] CPU: Processor Core ID: 0
[   82.984869] MCE: warning: using only 6 banks
[   82.984874] CPU0: Thermal monitoring enabled (TM2)
[   82.984877] mtrr: v2.0 (20020519)
[   82.984979] checking if image is initramfs... it is
[   83.509232] Freeing initrd memory: 7141k freed
[   83.513266] ACPI: Looking for DSDT ... not found!
[   83.555506] activating NMI Watchdog ... done.
[   83.555512] Using local APIC timer interrupts.
[   83.598287] Detected 20.834 MHz APIC timer.
[   83.598417] Booting processor 1/4 APIC 0x6
[   83.608963] Initializing CPU#1
[   83.687326] Calibrating delay using timer specific routine.. 4666.97 BogoMIPS (lpj=9333950)
[   83.687334] CPU: L1 I cache: 32K, L1 D cache: 32K
[   83.687335] CPU: L2 cache: 4096K
[   83.687338] CPU: Physical Processor ID: 3
[   83.687339] CPU: Processor Core ID: 0
[   83.687341] MCE: warning: using only 6 banks
[   83.687346] CPU1: Thermal monitoring enabled (TM2)
[   83.687806] Intel(R) Xeon(R) CPU            5140  @ 2.33GHz stepping 06
[   83.687813] APIC error on CPU1: 00(40)
[   83.687820] CPU 1: Syncing TSC to CPU 0.
[   83.687983] CPU 1: synchronized TSC with CPU 0 (last diff 3 cycles, maxerr 1029 cycles)
[   83.688060] Booting processor 2/4 APIC 0x1
[   83.699558] Initializing CPU#2
[   83.779149] Calibrating delay using timer specific routine.. 4666.95 BogoMIPS (lpj=9333919)
[   83.779158] CPU: L1 I cache: 32K, L1 D cache: 32K
[   83.779160] CPU: L2 cache: 4096K
[   83.779162] CPU: Physical Processor ID: 0
[   83.779163] CPU: Processor Core ID: 1
[   83.779165] MCE: warning: using only 6 banks
[   83.779170] CPU2: Thermal monitoring enabled (TM2)
[   83.779630] Intel(R) Xeon(R) CPU            5140  @ 2.33GHz stepping 06
[   83.779637] APIC error on CPU2: 00(40)
[   83.779644] CPU 2: Syncing TSC to CPU 0.
[   83.779740] CPU 2: synchronized TSC with CPU 0 (last diff 0 cycles, maxerr 567 cycles)
[   83.779847] Booting processor 3/4 APIC 0x7
[   83.792133] Initializing CPU#3
[   83.870974] Calibrating delay using timer specific routine.. 4666.98 BogoMIPS (lpj=9333974)
[   83.870982] CPU: L1 I cache: 32K, L1 D cache: 32K
[   83.870984] CPU: L2 cache: 4096K
[   83.870986] CPU: Physical Processor ID: 3
[   83.870988] CPU: Processor Core ID: 1
[   83.870990] MCE: warning: using only 6 banks
[   83.870994] CPU3: Thermal monitoring enabled (TM2)
[   83.871456] Intel(R) Xeon(R) CPU            5140  @ 2.33GHz stepping 06
[   83.871463] APIC error on CPU3: 00(40)
[   83.871471] CPU 3: Syncing TSC to CPU 0.
[   83.871634] CPU 3: synchronized TSC with CPU 0 (last diff 3 cycles, maxerr 1029 cycles)
[   83.871642] Brought up 4 CPUs
[   83.871679] time.c: Using HPET/TSC based timekeeping.
[   83.871681] testing NMI watchdog ... OK.
[   83.912003] NET: Registered protocol family 16
[   83.912025] ACPI: bus type pci registered
[   83.912030] PCI: Using configuration type 1
[   83.916659] PCI: Using MMCONFIG at e0000000
[   83.917342] ACPI: Subsystem revision 20051216
[   83.918769] ACPI: Interpreter enabled
[   83.918771] ACPI: Using IOAPIC for interrupt routing
[   83.919157] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   83.919160] PCI: Probing PCI hardware (bus 00)
[   83.919181] ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
[   83.920367] PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
[   83.929620] Boot video device is 0000:01:03.0
[   83.929845] PCI: Transparent bridge - 0000:00:1e.0
[   83.929881] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   83.931822] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[   83.932030] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPTA._PRT]
[   83.932138] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02._PRT]
[   83.932228] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.PEX2._PRT]
[   83.932498] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4._PRT]
[   83.932620] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4.IPE1._PRT]
[   83.933011] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4.IPE2._PRT]
[   83.933406] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT04._PRT]
[   83.933824] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT05.EEPB._PRT]
[   83.933931] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT05.EEPB.EPPB._PRT]
[   83.934978] ACPI: PCI Interrupt Link [LNKA] (IRQs *5 7 10 11)
[   83.935138] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *7 10 11)
[   83.935290] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 *10 11)
[   83.935443] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[   83.935594] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, disabled.
[   83.935746] ACPI: PCI Interrupt Link [LNKF] (IRQs *5 7 10 11)
[   83.935897] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
[   83.936048] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
[   83.936162] Linux Plug and Play Support v0.97 (c) Adam Belay
[   83.936169] pnp: PnP ACPI init
[   83.937354] pnp: PnP ACPI: found 10 devices
[   83.937364] PCI: Using ACPI for IRQ routing
[   83.937366] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   83.937572] hpet0: at MMIO 0xfed00000 (virtual 0xffffffffff5fe000), IRQs 2, 8, 0
[   83.937575] hpet0: 3 64-bit timers, 14318180 Hz
[   83.938715] pnp: 00:00: ioport range 0x408-0x40f has been reserved
[   83.938718] pnp: 00:00: ioport range 0x4d0-0x4d1 has been reserved
[   83.938720] pnp: 00:00: ioport range 0x700-0x71f has been reserved
[   83.939025] PCI: Bridge: 0000:05:00.0
[   83.939026]   IO window: disabled.
[   83.939100]   MEM window: disabled.
[   83.939146]   PREFETCH window: disabled.
[   83.939237] PCI: Bridge: 0000:05:01.0
[   83.939238]   IO window: disabled.
[   83.939329]   MEM window: disabled.
[   83.939375]   PREFETCH window: disabled.
[   83.939466] PCI: Bridge: 0000:04:00.0
[   83.939467]   IO window: disabled.
[   83.939557]   MEM window: disabled.
[   83.939603]   PREFETCH window: disabled.
[   83.939694] PCI: Bridge: 0000:04:00.3
[   83.939695]   IO window: disabled.
[   83.939786]   MEM window: disabled.
[   83.939832]   PREFETCH window: disabled.
[   83.939923] PCI: Bridge: 0000:00:02.0
[   83.939924]   IO window: disabled.
[   83.939926]   MEM window: fdd00000-fddfffff
[   83.939927]   PREFETCH window: disabled.
[   83.939929] PCI: Bridge: 0000:00:03.0
[   83.939930]   IO window: disabled.
[   83.939932]   MEM window: disabled.
[   83.939933]   PREFETCH window: disabled.
[   83.939935] PCI: Bridge: 0000:00:04.0
[   83.939936]   IO window: disabled.
[   83.939938]   MEM window: disabled.
[   83.939939]   PREFETCH window: disabled.
[   83.939943] PCI: Bridge: 0000:13:04.0
[   83.939944]   IO window: 5000-5fff
[   83.939948]   MEM window: fdf00000-fdffffff
[   83.939950]   PREFETCH window: f8000000-f83fffff
[   83.939953] PCI: Bridge: 0000:12:00.0
[   83.939955]   IO window: 4000-5fff
[   83.939958]   MEM window: fde00000-fdffffff
[   83.939961]   PREFETCH window: f8000000-f85fffff
[   83.939963] PCI: Bridge: 0000:00:05.0
[   83.939965]   IO window: 4000-5fff
[   83.939967]   MEM window: fde00000-fdffffff
[   83.939969]   PREFETCH window: f8000000-f85fffff
[   83.939971] PCI: Bridge: 0000:02:00.0
[   83.939972]   IO window: disabled.
[   83.939976]   MEM window: fa000000-fbffffff
[   83.939979]   PREFETCH window: f8600000-f86fffff
[   83.939983] PCI: Bridge: 0000:00:1c.0
[   83.939984]   IO window: disabled.
[   83.939987]   MEM window: fa000000-fbffffff
[   83.939990]   PREFETCH window: f8600000-f86fffff
[   83.939994] PCI: Bridge: 0000:00:1e.0
[   83.939995]   IO window: 2000-3fff
[   83.939998]   MEM window: f9e00000-f9ffffff
[   83.940001]   PREFETCH window: f0000000-f7ffffff
[   83.940008] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   83.940243] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   83.940564] GSI 16 sharing vector 0xA9 and IRQ 16
[   83.940567] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 169
[   83.940609] PCI: Setting latency timer of device 0000:05:00.0 to 64
[   83.940929] GSI 17 sharing vector 0xB1 and IRQ 17
[   83.940931] ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 17 (level, low) -> IRQ 177
[   83.940975] PCI: Setting latency timer of device 0000:05:01.0 to 64
[   83.941294] PCI: Setting latency timer of device 0000:04:00.3 to 64
[   83.941343] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   83.941347] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   83.941351] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   83.941361] PCI: Setting latency timer of device 0000:12:00.0 to 64
[   83.941376] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 169
[   83.941380] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   83.941395] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   83.941402] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   83.942208] IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
[   83.942647] audit: initializing netlink socket (disabled)
[   83.942661] audit(1223223322.104:1): initialized
[   83.942889] VFS: Disk quotas dquot_6.5.1
[   83.942907] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   83.942969] Initializing Cryptographic API
[   83.942973] io scheduler noop registered
[   83.942981] io scheduler anticipatory registered
[   83.942989] io scheduler deadline registered
[   83.943010] io scheduler cfq registered
[   83.961690] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   83.961694] pcie_portdrv_probe->Dev[25f7:8086] has invalid IRQ. Check vendor BIOS
[   83.961715] assign_interrupt_mode Found MSI capability
[   83.961761] Allocate Port Service[pcie00]
[   83.961805] Allocate Port Service[pcie01]
[   83.961845] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   83.961847] pcie_portdrv_probe->Dev[25e3:8086] has invalid IRQ. Check vendor BIOS
[   83.961860] assign_interrupt_mode Found MSI capability
[   83.961876] Allocate Port Service[pcie00]
[   83.961909] Allocate Port Service[pcie01]
[   83.961945] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   83.961947] pcie_portdrv_probe->Dev[25e4:8086] has invalid IRQ. Check vendor BIOS
[   83.961960] assign_interrupt_mode Found MSI capability
[   83.961976] Allocate Port Service[pcie00]
[   83.962011] Allocate Port Service[pcie01]
[   83.962057] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   83.962059] pcie_portdrv_probe->Dev[25e5:8086] has invalid IRQ. Check vendor BIOS
[   83.962071] assign_interrupt_mode Found MSI capability
[   83.962086] Allocate Port Service[pcie00]
[   83.962128] Allocate Port Service[pcie01]
[   83.962170] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 169
[   83.962174] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   83.962198] assign_interrupt_mode Found MSI capability
[   83.962225] Allocate Port Service[pcie00]
[   83.962275] Allocate Port Service[pcie03]
[   83.962448] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   83.962493] pcie_portdrv_probe->Dev[3500:8086] has invalid IRQ. Check vendor BIOS
[   83.963316] Allocate Port Service[pcie10]
[   83.963359] Allocate Port Service[pcie11]
[   83.963600] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 169
[   83.963636] PCI: Setting latency timer of device 0000:05:00.0 to 64
[   83.964504] assign_interrupt_mode Found MSI capability
[   83.965419] Allocate Port Service[pcie20]
[   83.965461] Allocate Port Service[pcie21]
[   83.965602] ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 17 (level, low) -> IRQ 177
[   83.965648] PCI: Setting latency timer of device 0000:05:01.0 to 64
[   83.966515] assign_interrupt_mode Found MSI capability
[   83.967430] Allocate Port Service[pcie20]
[   83.967474] Allocate Port Service[pcie21]
[   83.985215] Real Time Clock Driver v1.12
[   83.985331] hpet_resources: 0xfed00000 is busy
[   83.985340] Linux agpgart interface v0.101 (c) Dave Jones
[   83.985457] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[   83.997983] serio: i8042 AUX port at 0x60,0x64 irq 12
[   83.998912] serio: i8042 KBD port at 0x60,0x64 irq 1
[   83.998915] Serial: 8250/16550 driver $Revision: 1.90 $ 48 ports, IRQ sharing enabled
[   83.999061] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   83.999142] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   84.001013] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   84.001598] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   84.001648] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   84.001651] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   84.001839] mice: PS/2 mouse device common for all mice
[   84.003840] NET: Registered protocol family 2
[   84.058400] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   84.058851] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   84.062108] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   84.062640] TCP: Hash tables configured (established 262144 bind 65536)
[   84.062642] TCP reno registered
[   84.062757] TCP bic registered
[   84.062768] NET: Registered protocol family 1
[   84.062774] NET: Registered protocol family 8
[   84.062775] NET: Registered protocol family 20
[   84.062882] ACPI wakeup devices: 
[   84.062883] PCI0 
[   84.062885] ACPI: (supports S0 S4 S5)
[   84.063043] Freeing unused kernel memory: 180k freed
[   84.096385] vga16fb: initializing
[   84.096388] vga16fb: mapped to 0xffff8100000a0000
[   84.157151] input: AT Translated Set 2 keyboard as /class/input/input0
[   84.343416] Console: switching to colour frame buffer device 80x25
[   84.343419] fb0: VGA16 VGA frame buffer device
[   84.351250] Capability LSM initialized
[   84.376998] ACPI: Thermal Zone [THM0] (8 C)
[   84.659532] SCSI subsystem initialized
[   84.660131] Fusion MPT base driver 3.03.04
[   84.660133] Copyright (c) 1999-2005 LSI Logic Corporation
[   84.661558] Fusion MPT SPI Host driver 3.03.04
[   84.661603] GSI 18 sharing vector 0x3A and IRQ 18
[   84.661606] ACPI: PCI Interrupt 0000:14:01.0[A] -> GSI 19 (level, low) -> IRQ 58
[   84.661627] mptbase: Initiating ioc0 bringup
[   85.132854] ioc0: 53C1030: Capabilities={Initiator,Target}
[   85.442222] scsi0 : ioc0: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=58
[   86.191419]   Vendor: HP        Model: C7438A            Rev: ZP76
[   86.191429]   Type:   Sequential-Access                  ANSI SCSI revision: 03
[   89.007659] HP CISS Driver (v 2.6.8)
[   89.007685] cciss: Device 0x3238 has been found at bus 19 dev 8 func 0
[   89.007721] ACPI: PCI Interrupt 0000:13:08.0[A] -> GSI 19 (level, low) -> IRQ 58
[   89.049083] cciss: using DAC cycles
[   89.061180]       blocks= 143305920 block_size= 512
[   89.065213]       heads= 255, sectors= 32, cylinders= 17562
[   89.065214] 
[   89.065401]       blocks= 143305920 block_size= 512
[   89.065512]       heads= 255, sectors= 32, cylinders= 17562
[   89.065513] 
[   89.065517]  cciss/c0d0: p1 p2 p3 < p5 p6 p7 p8 p9 >
[   89.328012] ESB2: IDE controller at PCI slot 0000:00:1f.1
[   89.328021] ACPI: PCI Interrupt 0000:00:1f.1[A]: no GSI - using IRQ 7
[   89.328033] ESB2: chipset revision 9
[   89.328034] ESB2: not 100% native mode: will probe irqs later
[   89.328042]     ide0: BM-DMA at 0x0500-0x0507, BIOS settings: hda:DMA, hdb:pio
[   89.328054]     ide1: BM-DMA at 0x0508-0x050f, BIOS settings: hdc:pio, hdd:pio
[   89.328062] Probing IDE interface ide0...
[   90.064101] hda: HL-DT-STDVD+-RW GSA-H21L, ATAPI CD/DVD-ROM drive
[   90.399532] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   90.399572] Probing IDE interface ide1...
[   90.975016] hda: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
[   90.975022] Uniform CD-ROM driver Revision: 3.20
[   91.012776] usbcore: registered new driver usbfs
[   91.012791] usbcore: registered new driver hub
[   91.013416] USB Universal Host Controller Interface driver v2.3
[   91.013464] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 169
[   91.013473] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   91.013476] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   91.013774] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   91.013782] uhci_hcd 0000:00:1d.0: irq 169, io base 0x00001000
[   91.013855] hub 1-0:1.0: USB hub found
[   91.013861] hub 1-0:1.0: 2 ports detected
[   91.118534] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 177
[   91.118544] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   91.118548] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   91.118584] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   91.118596] uhci_hcd 0000:00:1d.1: irq 177, io base 0x00001020
[   91.118686] hub 2-0:1.0: USB hub found
[   91.118692] hub 2-0:1.0: 2 ports detected
[   91.223486] GSI 19 sharing vector 0x42 and IRQ 19
[   91.223490] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 66
[   91.223495] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   91.223498] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   91.223536] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   91.223543] uhci_hcd 0000:00:1d.2: irq 66, io base 0x00001040
[   91.223613] hub 3-0:1.0: USB hub found
[   91.223618] hub 3-0:1.0: 2 ports detected
[   91.328678] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 58
[   91.328684] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   91.328687] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   91.328719] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   91.328724] uhci_hcd 0000:00:1d.3: irq 58, io base 0x00001060
[   91.328795] hub 4-0:1.0: USB hub found
[   91.328800] hub 4-0:1.0: 2 ports detected
[   91.433784] GSI 20 sharing vector 0x4A and IRQ 20
[   91.433786] ACPI: PCI Interrupt 0000:01:04.4[B] -> GSI 22 (level, low) -> IRQ 74
[   91.433793] uhci_hcd 0000:01:04.4: UHCI Host Controller
[   91.433803] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
[   91.434696] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 5
[   91.434702] uhci_hcd 0000:01:04.4: irq 74, io base 0x00003800
[   91.434704] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 16 (level, low) -> IRQ 169
[   91.436330] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   91.436335] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   91.436375] ehci_hcd 0000:00:1d.7: debug port 1
[   91.436380] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   91.436411] hub 5-0:1.0: USB hub found
[   91.436419] hub 5-0:1.0: 2 ports detected
[   91.538797] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 6
[   91.538805] ehci_hcd 0000:00:1d.7: irq 169, io mem 0xf9df0000
[   91.542673] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   91.542745] hub 6-0:1.0: USB hub found
[   91.542751] hub 6-0:1.0: 8 ports detected
[   91.661522] Probing IDE interface ide1...
[   91.777144] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   92.171454] usb 5-2: new full speed USB device using uhci_hcd and address 3
[   92.322585] hub 5-2:1.0: USB hub found
[   92.325794] hub 5-2:1.0: 7 ports detected
[   92.449817] usbcore: registered new driver hiddev
[   92.456316] input: HP Virtual Keyboard as /class/input/input1
[   92.456324] input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
[   92.462760] input: HP Virtual Keyboard as /class/input/input2
[   92.462772] input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
[   92.462778] usbcore: registered new driver usbhid
[   92.462780] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   92.485347] Attempting manual resume
[   92.490003] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   92.490251] SGI XFS Quota Management subsystem
[   92.491361] XFS mounting filesystem cciss/c0d0p5
[   92.554316] Ending clean XFS mount for filesystem: cciss/c0d0p5
[   93.443420] ts: Compaq touchscreen protocol output
[   93.465883] st: Version 20050830, fixed bufsize 32768, s/g segs 256
[   93.465985] st 0:0:3:0: Attached scsi tape st0<4>st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA 1179647
[   93.476263] st 0:0:3:0: Attached scsi generic sg0 type 1
[   93.834234] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   93.841689] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   94.011531] input: PC Speaker as /class/input/input3
[   94.016056] hw_random hardware driver 1.0.0 loaded
[   94.020853] Floppy drive(s): fd0 is 1.44M
[   94.025928] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.4.30 (October 11, 2005)
[   94.025951] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 169
[   94.027405] eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B1) PCI-X 64-bit 133MHz found at mem fa000000, IRQ 169, node addr 0019bb35501e
[   94.170866] bnx2: eth0: using MSI
[   97.036527] floppy0: no floppy controllers found
[   97.157699] lp: driver loaded but no devices found
[   97.187872] netconsole: local port 6665
[   97.187875] netconsole: interface eth0
[   97.187877] netconsole: remote port 514
[   97.187879] netconsole: remote IP 192.168.120.3
[   97.187881] netconsole: remote ethernet address 00:e0:18:5b:e2:7b
[   97.187885] netconsole: local IP 192.168.120.1
[   97.196225] netconsole: network logging started
[   97.248145] Adding 2000084k swap on /dev/cciss/c0d0p2.  Priority:-1 extents:1 across:2000084k
[   97.351084] bnx2: eth0 NIC Link is Up, 1000 Mbps full duplex, receive & transmit flow control ON
[   97.371859] md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
[   97.371862] md: bitmap version 4.39
[   97.569823] device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
[   97.846475] cdrom: open failed.
[   98.255570] kjournald starting.  Commit interval 5 seconds
[   98.255699] EXT3 FS on cciss/c0d0p1, internal journal
[   98.255704] EXT3-fs: mounted filesystem with ordered data mode.
[   98.256906] XFS mounting filesystem cciss/c0d0p9
[   98.347776] Ending clean XFS mount for filesystem: cciss/c0d0p9
[   98.358369] XFS mounting filesystem cciss/c0d0p6
[   98.423140] Ending clean XFS mount for filesystem: cciss/c0d0p6
[   98.432706] XFS mounting filesystem cciss/c0d0p7
[   98.497717] Ending clean XFS mount for filesystem: cciss/c0d0p7
[   98.507407] XFS mounting filesystem cciss/c0d0p8
[   98.592454] Ending clean XFS mount for filesystem: cciss/c0d0p8
[   99.063872] NET: Registered protocol family 10
[   99.063989] lo: Disabled Privacy Extensions
[   99.064093] IPv6 over IPv4 tunneling driver
[  101.318108] tun: Universal TUN/TAP device driver, 1.6
[  101.318112] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  109.631635] eth0: no IPv6 routers present

--========GMX27107122774113395997--
