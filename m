Return-Path: <linux-kernel-owner+w=401wt.eu-S965392AbXBFT56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392AbXBFT56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXBFT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:57:58 -0500
Received: from mail.icabo.tv.br ([200.220.202.3]:53210 "EHLO mail.icabo.tv.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965391AbXBFT55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:57:57 -0500
Message-ID: <45C8DD9E.7010309@fliagreco.com.ar>
Date: Tue, 06 Feb 2007 16:57:18 -0300
From: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
User-Agent: Thunderbird 3.0a1 (Windows/20070206)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Marc Donner <donner@dbd-breitband.de>, linux-kernel@vger.kernel.org
Subject: Re: cpu load balancing problem on smp
References: <200702061832.17771.donner@dbd-breitband.de> <1170785364.7324.31.camel@laptopd505.fenrus.org> <200702061941.32907.donner@dbd-breitband.de> <45C8CC2A.90403@linux.intel.com>
In-Reply-To: <45C8CC2A.90403@linux.intel.com>
Content-Type: multipart/mixed;
 boundary="------------050908010702000604070907"
X-ICABO-MailScanner-Information: Please contact the ISP for more information
X-ICABO-MailScanner: Sem Virus encontrado
X-MailScanner-From: lkml@fliagreco.com.ar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050908010702000604070907
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> Marc Donner wrote:
>>>
>>> see http://www.irqbalance.org to get irqbalance
>>
>> I now have tried irqloadbalance, but the same problem.
>
>
> can you send me the output of
>
> cat /proc/interrupts
>
> (taken when you are or have been loading the network)
>
> maybe there's something fishy going on
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Please take a look at this, taken from the same machine running 
different vanilla kernels on fc6.
Current 2.6.19 fedora kernel, looks like 2.6.20rc3 (non mm) in the 
attachment.


--------------050908010702000604070907
Content-Type: text/plain;
 name="interrupts.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="interrupts.txt"

Mi42LjIwLXJjMw0KW3Jvb3RAc3F1aWQgfl0jIHJwbSAtcSBpcnFiYWxhbmNlDQppcnFiYWxh
bmNlLTAuNTUtMi5mYzYNCltyb290QHNxdWlkIH5dIyB1cHRpbWUNCiAxMTo1MTo1MCB1cCA2
IGRheXMsIDMwIG1pbiwgIDMgdXNlcnMsICBsb2FkIGF2ZXJhZ2U6IDUuMzEsIDUuMDgsIDQu
MDINCltyb290QHNxdWlkIH5dIyBzZXJ2aWNlIGlycWJhbGFuY2Ugc3RhdHVzDQppcnFiYWxh
bmNlIChwaWQgMjMxMCkgaXMgcnVubmluZy4uLg0KW3Jvb3RAc3F1aWQgfl0jIGNhdCAvcHJv
Yy9pbnRlcnJ1cHRzDQogICAgICAgICAgIENQVTAgICAgICAgQ1BVMSAgICAgICBDUFUyICAg
ICAgIENQVTMNCiAgMDogIDUyMDIwOTUxNyAgICAgICAgICAwICAgICAgICAgIDAgICAgICAg
ICAgMCAgIElPLUFQSUMtZWRnZSAgICAgIHRpbWVyDQogIDE6ICAgICAgICAgMTIgICAgICAg
ICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICBJTy1BUElDLWVkZ2UgICAgICBpODA0Mg0K
ICA4OiAgICAgICAgICAxICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgSU8t
QVBJQy1lZGdlICAgICAgcnRjDQogIDk6ICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAg
ICAwICAgICAgICAgIDAgICBJTy1BUElDLWZhc3Rlb2kgICBhY3BpDQogMTI6ICAgICAgICAx
MDMgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICBJTy1BUElDLWVkZ2UgICAg
ICBpODA0Mg0KIDE0OiAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAg
ICAwICAgSU8tQVBJQy1lZGdlICAgICAgbGliYXRhDQogMTU6ICAgICAgICAgIDAgICAgICAg
ICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICBJTy1BUElDLWVkZ2UgICAgICBsaWJhdGEN
CiAyMDogICAgIDEzODczNiAgMTg4MTk0MDk2ICAgICAgICAgIDAgICAgNjc5NzYzMCAgIElP
LUFQSUMtZmFzdGVvaSAgIGxpYmF0YQ0KIDIyOiAgICAgICAgICAwICAgICAgICAgIDAgICAg
ICAgICAgMCAgICAgICAgICAwICAgSU8tQVBJQy1mYXN0ZW9pICAgdWhjaV9oY2Q6dXNiMiwg
dWhjaV9oY2Q6dXNiNA0KIDIzOiAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAg
ICAgICAgICAwICAgSU8tQVBJQy1mYXN0ZW9pICAgdWhjaV9oY2Q6dXNiMSwgdWhjaV9oY2Q6
dXNiMywgZWhjaV9oY2Q6dXNiNQ0KMjI5NjogICAgICAgMTM2NyAgICAgICAgICAwICAgICAg
ICAgIDAgIDg0OTI3MDY1MyAgIFBDSS1NU0ktZWRnZSAgICAgIGV0aDENCjIyOTc6ICAgICAg
IDEwMjIgIDgzNTA4Mzk2OCAgICAgICAgICAwICAgICAgICAgIDAgICBQQ0ktTVNJLWVkZ2Ug
ICAgICBldGgwDQpOTUk6ICAgICAgNDc3NTYgICAgIDE0NjI0OSAgICAgIDQ3NjE3ICAgICAx
NDYxODYNCkxPQzogIDUxNjgyODc1MiAgNTE3MzMxOTA2ICA1MTY4Mjg2MTEgIDUxNzMzMTc3
MQ0KRVJSOiAgICAgICAgICAwDQoyLjYuMjAtcmMzLW1tMQ0KW3Jvb3RAc3F1aWQga2VybmVs
XSMgdXB0aW1lDQogMTI6MTc6NTQgdXAgMSBkYXksIDIxOjU4LCAgMiB1c2VycywgIGxvYWQg
YXZlcmFnZTogOS40NywgOS43OSwgMTAuMjgNCltyb290QHNxdWlkIGtlcm5lbF0jIGNhdCAv
cHJvYy9pbnRlcnJ1cHRzDQogICAgICAgICAgIENQVTAgICAgICAgQ1BVMSAgICAgICBDUFUy
ICAgICAgIENQVTMNCiAgMDogICA2MDAzMTU5MiAgIDYxMzUwMjQ3ICAgMjIyNzM3NzIgICAy
MTc4MDIxNSAgIElPLUFQSUMtZWRnZSAgICAgIHRpbWVyDQogIDE6ICAgICAgICAgIDAgICAg
ICAgICAgNiAgICAgICAgICAxICAgICAgICAgIDEgICBJTy1BUElDLWVkZ2UgICAgICBpODA0
Mg0KICA4OiAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMSAgICAgICAgICAwICAg
SU8tQVBJQy1lZGdlICAgICAgcnRjDQogIDk6ICAgICAgICAgIDAgICAgICAgICAgMCAgICAg
ICAgICAwICAgICAgICAgIDAgICBJTy1BUElDLWZhc3Rlb2kgICBhY3BpDQogMTI6ICAgICAg
ICAxNDggICAgICAgIDI4MyAgICAgICAgMTA0ICAgICAgICAxMzYgICBJTy1BUElDLWVkZ2Ug
ICAgICBpODA0Mg0KIDE0OiAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAg
ICAgICAwICAgSU8tQVBJQy1lZGdlICAgICAgbGliYXRhDQogMTU6ICAgICAgICAgIDAgICAg
ICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICBJTy1BUElDLWVkZ2UgICAgICBsaWJh
dGENCiAyMDogICAxMDQ4Mjc5NSAgICAxNDc3ODIxICAgICAgOTMzMDYgICAgIDY0MTYyOCAg
IElPLUFQSUMtZmFzdGVvaSAgIGxpYmF0YQ0KIDIyOiAgICAgICAgICAwICAgICAgICAgIDAg
ICAgICAgICAgMCAgICAgICAgICAwICAgSU8tQVBJQy1mYXN0ZW9pICAgdWhjaV9oY2Q6dXNi
MiwgdWhjaV9oY2Q6dXNiNA0KIDIzOiAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAg
MCAgICAgICAgICAwICAgSU8tQVBJQy1mYXN0ZW9pICAgdWhjaV9oY2Q6dXNiMSwgdWhjaV9o
Y2Q6dXNiMywgZWhjaV9oY2Q6dXNiNQ0KMjI5NjogICAgICAgIDQyNyAgICAgICAgNDI2ICAg
ICAgICA0MzYgIDEzNDU2MzAwOSAgIFBDSS1NU0ktZWRnZSAgICAgIGV0aDENCjIyOTc6ICAg
ICAgICAyNTIgICAgICAgIDI1MiAgMTM1OTI2NDcxICAgICAgICAyNTcgICBQQ0ktTVNJLWVk
Z2UgICAgICBldGgwDQpOTUk6ICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAg
ICAgICAgIDANCkxPQzogIDE2NDY2MTE0MCAgMTY1MTYzNTAzICAxNjQ2NjA5OTIgIDE2NTE2
MzMwNQ0KRVJSOiAgICAgICAgICAwDQo=
--------------050908010702000604070907--
