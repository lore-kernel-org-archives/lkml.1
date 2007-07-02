Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbXGBNoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbXGBNoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbXGBNoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:44:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:11850 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbXGBNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Cio1Y3cwli2UUi9POFXVcRf49wWTmoxztK65YK3AKsxR6eifBeYPkS23nNDSQegJaWr+Vf95dPGPsANyCul5OkEvAp8bBelpFa24b8dL/jwRoCp/pb6R92eMzp2msXOzmEWTLrdaGLitojjAgRzoPXjlRJL8ti8Lo+PVlA/mwgw=
Message-ID: <d120d5000707020643y1b4f03ebid0ae37adb40d0a53@mail.gmail.com>
Date: Mon, 2 Jul 2007 09:43:59 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: blink driver power saving
Cc: "Indan Zupancic" <indan@nul.nu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, bwalle@suse.de
In-Reply-To: <d120d5000707020642j752ca814l501aaa543f9babcf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_85005_9522796.1183383839883"
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
	 <200707021351.57965.ak@suse.de>
	 <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com>
	 <200707021439.27357.ak@suse.de>
	 <d120d5000707020642j752ca814l501aaa543f9babcf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_85005_9522796.1183383839883
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/2/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>
> I was thinking about something like the atached (untested and sorry
> for using attachment). It shoudl blink just one led (numLock) on any
> keyboard that has such LED (and allows to control it).
>

Argh, bad one. This one shoudl be better.

-- 
Dmitry

------=_Part_85005_9522796.1183383839883
Content-Type: text/plain; name="blink.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="blink.c"
X-Attachment-Id: f_f3n06i6p

LyoKICogRGVidWcgZHJpdmVyIHRoYXQgY29udGludW9zbHkgYmxpbmsgTEVEcyBvbiBrZXlib2Fy
ZHMKICoKICogQ29weXJpZ2h0IChjKSAyMDA3IERtaXRyeSBUb3Jva2hvdgogKi8KCi8qCiAqIFRo
aXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQv
b3IgbW9kaWZ5IGl0CiAqIHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UgdmVyc2lvbiAyIGFzIHB1Ymxpc2hlZAogKiBieSB0aGUgRnJlZSBTb2Z0d2FyZSBG
b3VuZGF0aW9uLgogKi8KCiNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KI2luY2x1ZGUgPGxpbnV4
L2lucHV0Lmg+CiNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiNpbmNsdWRlIDxsaW51eC93b3JrcXVl
dWUuaD4KI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KCk1PRFVMRV9BVVRIT1IoIkRtaXRyeSBUb3Jv
a2hvdiA8ZHRvckBtYWlsLnJ1PiIpOwpNT0RVTEVfREVTQ1JJUFRJT04oIkJsaW5rIGRyaXZlciIp
OwpNT0RVTEVfTElDRU5TRSgiR1BMIik7CgpzdHJ1Y3QgYmxpbmtlciB7CglzdHJ1Y3QgZGVsYXll
ZF93b3JrIHdvcms7CglzdHJ1Y3QgaW5wdXRfaGFuZGxlIGhhbmRsZTsKCWludCBzdGF0ZTsKfTsK
CnN0YXRpYyB2b2lkIGJsaW5rX3Rhc2tfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
CnsKCXN0cnVjdCBibGlua2VyICpibGlua2VyID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBi
bGlua2VyLCB3b3JrLndvcmspOwoKCWJsaW5rZXItPnN0YXRlID0gIWJsaW5rZXItPnN0YXRlOwoJ
aW5wdXRfaW5qZWN0X2V2ZW50KCZibGlua2VyLT5oYW5kbGUsIEVWX0xFRCwgTEVEX05VTUwsIGJs
aW5rZXItPnN0YXRlKTsKCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmYmxpbmtlci0+d29yaywgbXNl
Y3NfdG9famlmZmllcygyNTApKTsKfQoKc3RhdGljIHZvaWQgYmxpbmtfZXZlbnQoc3RydWN0IGlu
cHV0X2hhbmRsZSAqaGFuZGxlLCB1bnNpZ25lZCBpbnQgdHlwZSwKCQkgICAgICAgIHVuc2lnbmVk
IGludCBjb2RlLCBpbnQgZG93bikKewoJLyoKCSAqIFRoaXMgaXMgYSB2ZXJ5IHJhcmUgaGFuZGxl
ciB0aGF0IGRvZXMgbm90IHByb2Nlc3MgYW55IGlucHV0CgkgKiBldmVudHM7IGp1c3QgaW5qZWN0
cyB0aGVtLgoJICovCn0KCnN0YXRpYyBpbnQgYmxpbmtfY29ubmVjdChzdHJ1Y3QgaW5wdXRfaGFu
ZGxlciAqaGFuZGxlciwgc3RydWN0IGlucHV0X2RldiAqZGV2LAoJCQkgIGNvbnN0IHN0cnVjdCBp
bnB1dF9kZXZpY2VfaWQgKmlkKQp7CglzdHJ1Y3QgYmxpbmtlciAqYmxpbmtlcjsKCXN0cnVjdCBp
bnB1dF9oYW5kbGUgKmhhbmRsZTsKCWludCBlcnJvcjsKCglibGlua2VyID0ga3phbGxvYyhzaXpl
b2Yoc3RydWN0IGJsaW5rZXIpLCBHRlBfS0VSTkVMKTsKCWlmICghYmxpbmtlcikKCQlyZXR1cm4g
LUVOT01FTTsKCglJTklUX0RFTEFZRURfV09SSygmYmxpbmtlci0+d29yaywgYmxpbmtfdGFza19o
YW5kbGVyKTsKCgloYW5kbGUgPSAmYmxpbmtlci0+aGFuZGxlOwoJaGFuZGxlLT5kZXYgPSBkZXY7
CgloYW5kbGUtPmhhbmRsZXIgPSBoYW5kbGVyOwoJaGFuZGxlLT5uYW1lID0gImJsaW5rIjsKCWhh
bmRsZS0+cHJpdmF0ZSA9IGJsaW5rZXI7CgoJZXJyb3IgPSBpbnB1dF9yZWdpc3Rlcl9oYW5kbGUo
aGFuZGxlKTsKCWlmIChlcnJvcikKCQlnb3RvIGVycl9mcmVlX2hhbmRsZTsKCgllcnJvciA9IGlu
cHV0X29wZW5fZGV2aWNlKGhhbmRsZSk7CglpZiAoZXJyb3IpCgkJZ290byBlcnJfdW5yZWdpc3Rl
cl9oYW5kbGU7CgoJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZibGlua2VyLT53b3JrLCAwKTsKCgly
ZXR1cm4gMDsKCiBlcnJfdW5yZWdpc3Rlcl9oYW5kbGU6CglpbnB1dF91bnJlZ2lzdGVyX2hhbmRs
ZShoYW5kbGUpOwogZXJyX2ZyZWVfaGFuZGxlOgoJa2ZyZWUoaGFuZGxlKTsKCXJldHVybiBlcnJv
cjsKfQoKc3RhdGljIHZvaWQgYmxpbmtfZGlzY29ubmVjdChzdHJ1Y3QgaW5wdXRfaGFuZGxlICpo
YW5kbGUpCnsKCXN0cnVjdCBibGlua2VyICpibGlua2VyID0gaGFuZGxlLT5wcml2YXRlOwoKCWNh
bmNlbF9yZWFybWluZ19kZWxheWVkX3dvcmsoJmJsaW5rZXItPndvcmspOwoJaW5wdXRfY2xvc2Vf
ZGV2aWNlKGhhbmRsZSk7CglpbnB1dF91bnJlZ2lzdGVyX2hhbmRsZShoYW5kbGUpOwoJa2ZyZWUo
Ymxpbmtlcik7Cn0KCnN0YXRpYyBjb25zdCBzdHJ1Y3QgaW5wdXRfZGV2aWNlX2lkIGJsaW5rX2lk
c1tdID0gewoJewoJCS5mbGFncyA9IElOUFVUX0RFVklDRV9JRF9NQVRDSF9FVkJJVCB8IElOUFVU
X0RFVklDRV9JRF9NQVRDSF9MRURCSVQsCgkJLmV2Yml0ID0geyBCSVQoRVZfTEVEKSB9LAoJCS5s
ZWRiaXQgPSB7IFtMT05HKExFRF9OVU1MKV0gPSBCSVQoTEVEX05VTUwpIH0sCgl9LAoJeyB9Cn07
CgpzdGF0aWMgc3RydWN0IGlucHV0X2hhbmRsZXIgYmxpbmtfaGFuZGxlciA9IHsKCS5ldmVudAkJ
PSBibGlua19ldmVudCwKCS5jb25uZWN0CT0gYmxpbmtfY29ubmVjdCwKCS5kaXNjb25uZWN0CT0g
YmxpbmtfZGlzY29ubmVjdCwKCS5uYW1lCQk9ICJibGluayIsCgkuaWRfdGFibGUJPSBibGlua19p
ZHMsCn07CgpzdGF0aWMgaW50IF9faW5pdCBibGlua19oYW5kbGVyX2luaXQodm9pZCkKewoJcmV0
dXJuIGlucHV0X3JlZ2lzdGVyX2hhbmRsZXIoJmJsaW5rX2hhbmRsZXIpOwp9CgpzdGF0aWMgdm9p
ZCBfX2V4aXQgYmxpbmtfaGFuZGxlcl9leGl0KHZvaWQpCnsKCWlucHV0X3VucmVnaXN0ZXJfaGFu
ZGxlcigmYmxpbmtfaGFuZGxlcik7CglmbHVzaF9zY2hlZHVsZWRfd29yaygpOwp9Cgptb2R1bGVf
aW5pdChibGlua19oYW5kbGVyX2luaXQpOwptb2R1bGVfZXhpdChibGlua19oYW5kbGVyX2V4aXQp
Owo=
------=_Part_85005_9522796.1183383839883--
