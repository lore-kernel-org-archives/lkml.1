Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZFCGtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZFCGtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZFCGtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:49:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:23016 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZFCGtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VnwQf3VELMgvIt5aK3O03RfwijMgNU6sg9jEV3rWMfkxA1DRUAGYlQsG61FqpN5GoW
         897hbWshyk1s5wbtf5fghX8HKemtrycBsHUNZOFmCjO4Mpr/eYkUim19BpWqLq6imfID
         2O4XMyYIWy5neQxJTIj+y/el/BJFPIegESgEA=
MIME-Version: 1.0
In-Reply-To: <20090602214745.GB25921@kroah.com>
References: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com>
	 <20090602214745.GB25921@kroah.com>
Date: Wed, 3 Jun 2009 12:19:26 +0530
Message-ID: <430c80e90906022349l6fa7a9b4lb73f0ab1980b3e63@mail.gmail.com>
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
From: Pranith Kumar <bobby.prani@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636e1fa2c6fabcb046b6c0f3c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e1fa2c6fabcb046b6c0f3c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 6/3/09, Greg KH <greg@kroah.com> wrote:
> On Fri, May 29, 2009 at 01:24:16PM +0530, Pranith Kumar wrote:
>> Hi Greg,
>>
>> This patch fixes the following warning
>>
>> drivers/staging/otus/ioctl.c: In function `usbdrv_wpa_ioctl':
>> drivers/staging/otus/ioctl.c:2269: warning: ISO C90 forbids mixed
>> declarations and code
>> drivers/staging/otus/ioctl.c: In function `usbdrv_ioctl':
>> drivers/staging/otus/ioctl.c:2448: warning: ISO C90 forbids mixed
>> declarations and code
>>

> Your patch is line-wrapped and the tabs seem to be stripped out, making
> it impossible to apply :(
>
> care to try again?
>

Hi Greg,

I am using Gmail, which does this. I haven't figured out how to
configure this thing yet.

Please accept the patch as attachment.

Thanks,
Pranith

--001636e1fa2c6fabcb046b6c0f3c
Content-Type: application/octet-stream; name="staging_patch.diff"
Content-Disposition: attachment; filename="staging_patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9vdHVzL2lvY3RsLmMgYi9kcml2ZXJzL3N0YWdp
bmcvb3R1cy9pb2N0bC5jCmluZGV4IGNlMDQyMTguLjI2YmQ5OTkgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy9vdHVzL2lvY3RsLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL290dXMvaW9jdGwu
YwpAQCAtMjA0NSw2ICsyMDQ1LDcgQEAgaW50IHVzYmRydl93cGFfaW9jdGwoc3RydWN0IG5ldF9k
ZXZpY2UgKmRldiwgc3RydWN0IGF0aHJfd2xhbl9wYXJhbSAqemRwYXJtKQogICAgICAgIHN0cnVj
dCB6c0tleUluZm8ga2V5SW5mbzsKICAgICAgICBzdHJ1Y3QgdXNiZHJ2X3ByaXZhdGUgKm1hY3Ag
PSBkZXYtPm1sX3ByaXY7CiAgICAgICAgdTE2X3QgdmFwSWQgPSAwOworICAgIGludCBpaTsKCiAg
ICAgICAgLyogem13X2dldF93bGFuX2RldihkZXYpOyAqLwoKQEAgLTIxNjgsNyArMjE2OSw2IEBA
IGludCB1c2JkcnZfd3BhX2lvY3RsKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBhdGhy
X3dsYW5fcGFyYW0gKnpkcGFybSkKICAgICAgICAgICAgICAgIC8qIERVTVAga2V5IGNvbnRleHQg
Ki8KICAgICAgICAgICAgICAgIC8qICNpZmRlZiBXUEFfREVCVUcgKi8KICAgICAgICAgICAgICAg
IGlmIChrZXlJbmZvLmtleUxlbmd0aCA+IDApIHsKLSAgICAgICAgICAgICAgICAgICAgICAgaW50
IGlpOwogICAgICAgICAgICAgICAgICAgICAgICBwcmludGsoS0VSTl9XQVJOSU5HCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJPdHVzOiBLZXkgQ29udGV4
dDpcbiIpOwogICAgICAgICAgICAgICAgICAgICAgICBmb3IgKGlpID0gMDsgaWkgPCBrZXlJbmZv
LmtleUxlbmd0aDsgKSB7CkBAIC0yMjY2LDcgKzIyNjYsNiBAQCBpbnQgdXNiZHJ2X3dwYV9pb2N0
bChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgYXRocl93bGFuX3BhcmFtICp6ZHBhcm0p
CiAgICAgICAgICAgICAgICAvKiB6ZmlXbGFuU2V0V3BhSWUoZGV2LCB6ZHBhcm0tPnUuZ2VuZXJp
Y19lbGVtLmRhdGEsCiAgICAgICAgICAgICAgICAqIHpkcGFybS0+dS5nZW5lcmljX2VsZW0ubGVu
KTsKICAgICAgICAgICAgICAgICovCi0gICAgICAgICAgICAgICBpbnQgaWk7CiAgICAgICAgICAg
ICAgICB1OF90IGxlbiA9IHpkcGFybS0+dS5nZW5lcmljX2VsZW0ubGVuOwogICAgICAgICAgICAg
ICAgdThfdCAqd3BhaWUgPSAodThfdCAqKXpkcGFybS0+dS5nZW5lcmljX2VsZW0uZGF0YTsKCkBA
IC0yNDAxLDcgKzI0MDAsNyBAQCBpbnQgdXNiZHJ2X2lvY3RsKHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsIHN0cnVjdCBpZnJlcSAqaWZyLCBpbnQgY21kKQogICAgICAgIHN0cnVjdCBhdGhyX3dsYW5f
cGFyYW0gemRwYXJtOwogICAgICAgIHN0cnVjdCB1c2JkcnZfcHJpdmF0ZSAqbWFjcCA9IGRldi0+
bWxfcHJpdjsKCi0gICAgICAgaW50IGVyciA9IDA7CisgICAgICAgaW50IGVyciA9IDAsIHZhbCA9
IDA7CiAgICAgICAgaW50IGNoYW5nZWQgPSAwOwoKICAgICAgICAvKiByZWdwID0gbWFjcC0+cmVn
cDsgKi8KQEAgLTI0NDUsNyArMjQ0NCw3IEBAIGludCB1c2JkcnZfaW9jdGwoc3RydWN0IG5ldF9k
ZXZpY2UgKmRldiwgc3RydWN0IGlmcmVxICppZnIsIGludCBjbWQpCiAgICAgICAgICAgICAgICAg
ICAgICAgIGVyciA9IC1FUEVSTTsKICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7CiAgICAg
ICAgICAgICAgICB9Ci0gICAgICAgICAgICAgICBpbnQgdmFsID0gKigoaW50ICopIHdycS0+dS5u
YW1lKTsKKyAgICAgICAgICAgICAgIHZhbCA9ICooKGludCAqKSB3cnEtPnUubmFtZSk7CiAgICAg
ICAgICAgICAgICBpZiAoKHZhbCA8IDApIHx8ICh2YWwgPiAyKSkgewogICAgICAgICAgICAgICAg
ICAgICAgICBlcnIgPSAtRUlOVkFMOwogICAgICAgICAgICAgICAgICAgICAgICBicmVhazsKCg==
--001636e1fa2c6fabcb046b6c0f3c--
