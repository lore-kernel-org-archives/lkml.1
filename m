Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZFWIR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZFWIR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZFWIRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:17:12 -0400
Received: from mail-yx0-f196.google.com ([209.85.210.196]:48369 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZFWIRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lIm4/N2OWidq+ZXa5iatg0OFceYtwMiE3g4Odmu1do57evDUnrW8KDQLxVAhUonLYm
         xUkO9SqwQXvLhXd9bnKQiVKKehj3AenoSNHiIAccqDGHQS9bpe16+OJy/8bei0ZZYpIk
         aHw+HZMP4yrvsPMWZMbR8FHSu62o+974m6DKg=
MIME-Version: 1.0
Date: Tue, 23 Jun 2009 16:17:06 +0800
Message-ID: <fc71709d0906230117h2bee4d7en9f3aadeae3cb9545@mail.gmail.com>
Subject: mm: dirty page problem
From: xue yong <ultraice.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016368e1b8bcad073046cff9d03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016368e1b8bcad073046cff9d03
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I wrote a test program. It  mmap  a file and do some write, so some
pages become dirty.
and then I do "cat /proc/meminfo", so I get dirty pages that I have
written. this happened in my home
computer with debian, self compiled kernel 2.6.18-5 installed.


but in my company, on the servers (suse kernel 2.6.16.54), after the
test program have written the data, there was no change in
dirty pages column of "cat /proc/meminfo" 's output. after I killed
the test program, the dirty pages changed immediately.


I dont know why such different behavior, can you help me?


becauce we want a program mmap some files, and after the files'
contents were changed, the OS can write out these dirty
data back to disk periodly.




Best regards!

--0016368e1b8bcad073046cff9d03
Content-Type: application/octet-stream; name="mmaptest.c"
Content-Disposition: attachment; filename="mmaptest.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwace4j40

I2luY2x1ZGUgPHN0ZGxpYi5oPg0KI2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8c3lzL3R5
cGVzLmg+DQojaW5jbHVkZSA8c3lzL21tYW4uaD4NCiNpbmNsdWRlIDxzeXMvdGltZS5oPg0KI2lu
Y2x1ZGUgPHRpbWUuaD4NCiNpbmNsdWRlIDxzeXMvc3RhdC5oPg0KI2luY2x1ZGUgPGZjbnRsLmg+
DQppbnQgbWFpbigpDQp7DQogICAgaW50IGZkOw0KICAgIGNoYXIgKnBtOw0KICAgIHN0cnVjdCBz
dGF0IHN0Ow0KICAgIHBpZF90IHA7DQovLyAgICBwID0gZm9yaygpOw0KICAgIGZkID0gb3Blbigi
L2hvbWUvaWNlL21tYXAuZGF0IiwgT19SRFdSKTsNCiAgICBpZiggZmQgPCAwICl7DQogICAgICAg
IHBlcnJvcigib3BlbiBtbWFwLmRhdCBlcnJvciIpOw0KICAgICAgICBleGl0KDEpOw0KICAgIH0N
CiAgICBpZiAoIGZzdGF0KGZkLCAmc3QpICE9IDAgKXsNCiAgICAgICAgcGVycm9yKCJzdGF0IGVy
cm9yIik7DQogICAgICAgIGV4aXQoMSk7DQogICAgfQ0KICAgIHBtID0gKGNoYXIqKSBtbWFwKCBO
VUxMLCBzdC5zdF9zaXplLCBQUk9UX1dSSVRFIHwgUFJPVF9SRUFEICwgTUFQX1NIQVJFRCAsIGZk
LCAwKTsNCi8vICAgIHBtID0gKGNoYXIqKSBtbWFwKCBOVUxMLCBzdC5zdF9zaXplLCAgUFJPVF9S
RUFEICwgTUFQX1NIQVJFRCAsIGZkLCAwKTsNCiAgICBpZiAoIHBtIDwgMCB8fCBwbSA9PSBNQVBf
RkFJTEVEICl7DQogICAgICAgIHBlcnJvcigibW1hcCBmYWlsZWQiKTsNCiAgICAgICAgZXhpdCgx
KTsNCiAgICB9DQogICAgDQogICAgc3RydWN0IHRpbWV2YWwgdEJlZ2luLCB0RW5kOw0KICAgIGJ6
ZXJvKCAmdEJlZ2luLCBzaXplb2YodEJlZ2luKSApOw0KICAgIGJ6ZXJvKCAmdEVuZCwgc2l6ZW9m
KHRFbmQpICk7DQoNCiAgICBnZXR0aW1lb2ZkYXkoICZ0QmVnaW4sIE5VTEwpOw0KICAgIGludCBp
Ow0KICAgIGNoYXIgYnVmZmVyWzQwOTZdOw0KLy8gICAgcmVhZCggZmQsIGJ1ZmZlciwgNDA5Nik7
DQogICAgd2hpbGUoMSl7DQogICAgZm9yKCBpID0gMDsgaSA8IDEwMjQqMTAwOyArK2kgKQ0KICAg
IHsNCiAgICAgICAgbWVtY3B5KCBwbSArIDQwOTYqaSxidWZmZXIsIDQwOTYgKTsNCi8vICAgICAg
ICBwd3JpdGUoIGZkLCBidWZmZXIsIDQwOTYsIGkgKiA0MDk2ICk7DQoNCiAgICB9DQogICAgc2xl
ZXAoMzAwKTsNCiAgICB9DQovLyAgICBtbG9ja2FsbChNQ0xfQ1VSUkVOVCk7DQovLw0KICAgIGdl
dHRpbWVvZmRheSggJnRFbmQsIE5VTEwpOw0KICAgIGludCBsaVRpbWVEaWZmID0gKCh0RW5kLnR2
X3NlYyAtIHRCZWdpbi50dl9zZWMpICogMTAwMDAwMCArIHRFbmQudHZfdXNlYyAtIHRCZWdpbi50
dl91c2VjICkgLyAxMDAwOw0KICAgIHByaW50ZigiJWQgbXNcbiIsIGxpVGltZURpZmYgKTsNCiAg
ICBwcmludGYoIm1zeW5jXG4iKTsNCiAgICBtc3luYyggcG0sIHN0LnN0X3NpemUsIE1TX1NZTkMg
KTsNCiAgICBtdW5tYXAoIHBtLCBzdC5zdF9zaXplICk7DQovLyAgICBzbGVlcCg2MDApOw0KfQ==
--0016368e1b8bcad073046cff9d03--
