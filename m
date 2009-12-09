Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZLIV3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZLIV3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZLIV3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:29:17 -0500
Received: from katapult.uhulinux.hu ([195.228.155.101]:32801 "EHLO
	katapult.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZLIV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:29:17 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 16:29:16 EST
Message-ID: <4B2014DE.4040605@uhulinux.hu>
Date: Wed, 09 Dec 2009 22:21:34 +0100
From: =?UTF-8?B?VGFtw6FzaSBKw6Fub3M=?= <janusz@uhulinux.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alex Custov <alex.custov@gmail.com>, linux-kernel@vger.kernel.org,
       janusz@uhulinux.hu
Subject: Re: touchscreen wirh 2.6.26
References: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>  <alpine.LRH.2.00.0911271158560.3659@twin.jikos.cz>  <39840bc80911270403q83c16efy872cc1f72a0344ee@mail.gmail.com>  <alpine.LSU.2.00.0911271308270.6953@wotan.suse.de> <39840bc80911270936n2cb568e6wd33a376ab59a6e62@mail.gmail.com> <alpine.LSU.2.00.0911280025460.6953@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0911280025460.6953@wotan.suse.de>
Content-Type: multipart/mixed;
 boundary="------------050106070503020403060909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050106070503020403060909
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi!

I wrote a small (and really ugly) uinput driver to this device. I hope 
this helps somebody to write a proper driver for this touchscreen.


2009-11-28 00:30 keltezéssel, Jiri Kosina írta:
> On Fri, 27 Nov 2009, Alex Custov wrote:
>
>    
>> Bus 004 Device 002: ID 0408:3000 Quanta Computer, Inc.
>> Device Descriptor:
>>    bLength                18
>>    bDescriptorType         1
>>    bcdUSB               1.10
>>    bDeviceClass            0 (Defined at Interface level)
>>    bDeviceSubClass         0
>>    bDeviceProtocol         0
>>    bMaxPacketSize0        64
>>    idVendor           0x0408 Quanta Computer, Inc.
>>    idProduct          0x3000
>>      
> Unfortunately, this touchscreen is not (yet) neither supported by
> usbtouchscreen kernel driver, nor is it apparently HID standard compliant,
> so HID driver can't do much with it as well.
>
> You will have to reverse-engineer the data protocol the touchscreen is
> sending. It's usually quite easy, in cases in which the device doesn't
> require complex initialization before it can become functional.
>
>    


--------------050106070503020403060909
Content-Type: text/plain;
 name="acer-t230H.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="acer-t230H.c"

Ly8gdWlucHV0LmMKI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2lu
Y2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPGZj
bnRsLmg+CiNpbmNsdWRlIDxsaW51eC9pbnB1dC5oPgojaW5jbHVkZSA8bGludXgvdWlucHV0
Lmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3lzL3RpbWUuaD4KI2luY2x1ZGUg
PHN5cy90eXBlcy5oPgojaW5jbHVkZSA8dW5pc3RkLmg+Ci8qCiAqIEdsb2JhbHMgCiAqLwpz
dGF0aWMgaW50ICAgICAgdWlucF9mZCA9IC0xOwpzdHJ1Y3QgdWlucHV0X3VzZXJfZGV2IHVp
bnA7CS8vIHVJbnB1dCBkZXZpY2Ugc3RydWN0dXJlCnN0cnVjdCBpbnB1dF9ldmVudCBldmVu
dDsJLy8gSW5wdXQgZGV2aWNlIHN0cnVjdHVyZQoKLyoKICogU2V0dXAgdGhlIHVpbnB1dCBk
ZXZpY2UgCiAqLwppbnQgc2V0dXBfdWlucHV0X2RldmljZSgpIHsKICAgIC8vIFRlbXBvcmFy
eSB2YXJpYWJsZQogICAgaW50ICAgICAgICAgICAgIGkgPSAwOwoKICAgIC8vIE9wZW4gdGhl
IGlucHV0IGRldmljZQogICAgdWlucF9mZCA9IG9wZW4oIi9kZXYvaW5wdXQvdWlucHV0Iiwg
T19XUk9OTFkgfCBPX05ERUxBWSk7CiAgICBpZiAoJnVpbnBfZmQgPT0gTlVMTCkgewoJCXBy
aW50ZigiVW5hYmxlIHRvIG9wZW4gL2Rldi9pbnB1dC91aW5wdXRcbiIpOwoJCXJldHVybiAt
MTsKICAgIH0KICAgIG1lbXNldCgmdWlucCwgMCwgc2l6ZW9mKHVpbnApKTsJLy8gSW50aWFs
aXplIHRoZSB1SW5wdXQgZGV2aWNlIHRvIE5VTEwKICAgIHN0cm5jcHkodWlucC5uYW1lLCAi
QWNlciBUMjMwSCIsIFVJTlBVVF9NQVhfTkFNRV9TSVpFKTsKICAgIHVpbnAuaWQudmVyc2lv
biA9IDQ7CiAgICB1aW5wLmlkLmJ1c3R5cGUgPSBCVVNfVVNCOwogICAgdWlucC5hYnNtYXhb
QUJTX1hdID0gMTkyMCsxNDQwOyAvLyBpIGhhdmUgYW5vdGhlciBtb25pdG9yIGNvbm5lY3Rl
ZDsKICAgIHVpbnAuYWJzbWluW0FCU19YXSA9IDA7CiAgICB1aW5wLmFic2Z1enpbQUJTX1hd
ID0gMzsKICAgIHVpbnAuYWJzbWluW0FCU19YXSA9IDA7CgogICAgdWlucC5hYnNtYXhbQUJT
X1ldID0gMTA4MDsKICAgIHVpbnAuYWJzbWluW0FCU19ZXSA9IDA7CiAgICB1aW5wLmFic2Z1
enpbQUJTX1ldID0gMzsKICAgIHVpbnAuYWJzbWluW0FCU19ZXSA9IDA7CgogICAgLy8gU2V0
dXAgdGhlIHVpbnB1dCBkZXZpY2UKICAgIGlvY3RsKHVpbnBfZmQsIFVJX1NFVF9FVkJJVCwg
RVZfS0VZKTsKICAgIGlvY3RsKHVpbnBfZmQsIFVJX1NFVF9FVkJJVCwgRVZfQUJTKTsKICAg
IGlvY3RsKHVpbnBfZmQsIFVJX1NFVF9BQlNCSVQsIEFCU19YKTsKICAgIGlvY3RsKHVpbnBf
ZmQsIFVJX1NFVF9BQlNCSVQsIEFCU19ZKTsKICAgIGlvY3RsKHVpbnBfZmQsIFVJX1NFVF9L
RVlCSVQsIEJUTl9MRUZUKTsKCiAgICAvKgogICAgICogQ3JlYXRlIGlucHV0IGRldmljZSBp
bnRvIGlucHV0IHN1Yi1zeXN0ZW0gCiAgICAgKi8KICAgIHdyaXRlKHVpbnBfZmQsICZ1aW5w
LCBzaXplb2YodWlucCkpOwogICAgaWYgKGlvY3RsKHVpbnBfZmQsIFVJX0RFVl9DUkVBVEUp
KSB7CgkJcHJpbnRmKCJVbmFibGUgdG8gY3JlYXRlIFVJTlBVVCBkZXZpY2UuXG4iKTsKCQly
ZXR1cm4gLTE7CiAgICB9CiAgICByZXR1cm4gMTsKfQoKdm9pZCBwdWtrKCkgewogICAgaW50
ICAgICAgICAgICAgIGZkOwogICAgdW5zaWduZWQgaW50ICAgIHgsCiAgICAgICAgICAgICAg
ICAgICAgeSwKICAgICAgICAgICAgICAgICAgICB4eCwKICAgICAgICAgICAgICAgICAgICB5
eTsKICAgIHVuc2lnbmVkIGNoYXIgICBidWZbMzBdOwoKICAgIGZkID0gb3BlbigiL2Rldi9o
aWRyYXc2IiwgT19SRE9OTFkpOwogICAgd2hpbGUgKDEpIHsKCQlyZWFkKGZkLCBidWYsIHNp
emVvZihidWYpKTsKCQl4ID0gYnVmWzRdICsgKHVuc2lnbmVkIGludCkgYnVmWzVdICogMjU2
OwoJCXkgPSBidWZbNl0gKyAodW5zaWduZWQgaW50KSBidWZbN10gKiAyNTY7CgkJeHggPSBi
dWZbMTBdICsgKHVuc2lnbmVkIGludCkgYnVmWzExXSAqIDI1NjsKCQl5eSA9IGJ1ZlsxMl0g
KyAodW5zaWduZWQgaW50KSBidWZbMTNdICogMjU2OwoKCQkvLyBzZXQgeCAmIHkKCQltZW1z
ZXQoJmV2ZW50LCAwLCBzaXplb2YoZXZlbnQpKTsKCQlnZXR0aW1lb2ZkYXkoJmV2ZW50LnRp
bWUsIE5VTEwpOwoJCWV2ZW50LnR5cGUgPSBFVl9BQlM7CgkJZXZlbnQuY29kZSA9IEFCU19Y
OwoJCWV2ZW50LnZhbHVlID0geCArIDE0NDA7IC8vIGEgaGF2ZSBhbm90aGVyIG1vbml0b3Ig
Y29ubmVjdGVkIDopCgkJd3JpdGUodWlucF9mZCwgJmV2ZW50LCBzaXplb2YoZXZlbnQpKTsK
CQlldmVudC50eXBlID0gRVZfQUJTOwoJCWV2ZW50LmNvZGUgPSBBQlNfWTsKCQlldmVudC52
YWx1ZSA9IHk7CgkJd3JpdGUodWlucF9mZCwgJmV2ZW50LCBzaXplb2YoZXZlbnQpKTsKCQll
dmVudC50eXBlID0gRVZfU1lOOwoJCWV2ZW50LmNvZGUgPSBTWU5fUkVQT1JUOwoJCWV2ZW50
LnZhbHVlID0gMDsKCQl3cml0ZSh1aW5wX2ZkLCAmZXZlbnQsIHNpemVvZihldmVudCkpOwoK
CQlpZiAoYnVmWzJdID09IDcpIHsJLy8gQlROMSBwcmVzc2VkCgkJICAgIG1lbXNldCgmZXZl
bnQsIDAsIHNpemVvZihldmVudCkpOwoJCSAgICBnZXR0aW1lb2ZkYXkoJmV2ZW50LnRpbWUs
IE5VTEwpOwoJCSAgICBldmVudC50eXBlID0gRVZfS0VZOwoJCSAgICBldmVudC5jb2RlID0g
QlROX0xFRlQ7CgkJICAgIGV2ZW50LnZhbHVlID0gMTsKCQkgICAgd3JpdGUodWlucF9mZCwg
JmV2ZW50LCBzaXplb2YoZXZlbnQpKTsKCQkgICAgZXZlbnQudHlwZSA9IEVWX1NZTjsKCQkg
ICAgZXZlbnQuY29kZSA9IFNZTl9SRVBPUlQ7CgkJICAgIGV2ZW50LnZhbHVlID0gMDsKCQkg
ICAgd3JpdGUodWlucF9mZCwgJmV2ZW50LCBzaXplb2YoZXZlbnQpKTsKCQl9CgoJCWlmIChi
dWZbMl0gPT0gNCkgewkvLyBCVE4xIHJlbGVhc2VkCgkJICAgIG1lbXNldCgmZXZlbnQsIDAs
IHNpemVvZihldmVudCkpOwoJCSAgICBnZXR0aW1lb2ZkYXkoJmV2ZW50LnRpbWUsIE5VTEwp
OwoJCSAgICBldmVudC50eXBlID0gRVZfS0VZOwoJCSAgICBldmVudC5jb2RlID0gQlROX0xF
RlQ7CgkJICAgIGV2ZW50LnZhbHVlID0gMDsKCQkgICAgd3JpdGUodWlucF9mZCwgJmV2ZW50
LCBzaXplb2YoZXZlbnQpKTsKCQkgICAgZXZlbnQudHlwZSA9IEVWX1NZTjsKCQkgICAgZXZl
bnQuY29kZSA9IFNZTl9SRVBPUlQ7CgkJICAgIGV2ZW50LnZhbHVlID0gMDsKCQkgICAgd3Jp
dGUodWlucF9mZCwgJmV2ZW50LCBzaXplb2YoZXZlbnQpKTsKCQl9CgoJCXByaW50ZigiXG4l
dXgldSAldXgldSBbJXVdXG4iLCB4LCB5LCB4eCwgeXksIGJ1ZlsyXSk7CiAgICB9CiAgICBj
bG9zZShmZCk7Cn0KCmludCBtYWluKCkgewogICAgLy8gUmV0dXJuIGFuIGVycm9yIGlmIGRl
dmljZSBub3QgZm91bmQuCiAgICBpZiAoc2V0dXBfdWlucHV0X2RldmljZSgpIDwgMCkgewoJ
CXByaW50ZigiVW5hYmxlIHRvIGZpbmQgdWlucHV0IGRldmljZVxuIik7CgkJcmV0dXJuIC0x
OwogICAgfQogICAgcHVraygpOwogICAgaW9jdGwodWlucF9mZCwgVUlfREVWX0RFU1RST1kp
OwogICAgY2xvc2UodWlucF9mZCk7CiAgICByZXR1cm4gMDsKfQo=
--------------050106070503020403060909--
