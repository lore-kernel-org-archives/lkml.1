Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZAUOTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZAUOTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZAUOTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:19:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:11714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZAUOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:19:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rStjLbOINEH84EOpajS6HpB3eDMBexWaA4G/GoNSj+WQN1myaadIycObo1iyysRoJs
         gpMP//gpvoIHP0kJlgzqmPiOHFmtHtOMVc9hVffDZrlzthkongtIiZn9wQyBndpHm1ev
         SUnJWPoBGyj6TWTWZdmF6lIFvHeDNEcPFyWLI=
MIME-Version: 1.0
Date: Wed, 21 Jan 2009 15:19:28 +0100
Message-ID: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com>
Subject: ext4 no space left
From: Victor Pelt <victor.pelt@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016367659ebfc6b260460fed77e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016367659ebfc6b260460fed77e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hey,

i tried to switch my root partition to ext4 (from reiserfs) but i ran
into problems when copying over all the data that it says 'no space
left on the device'
i'm running 2.6.28-gentoo-r1 (based on 2.6.28.1 if i'm not mistaken)

i deleted quite a bit and then tried copying again, this time it still
gave the same error but more files (data wise didn't count if the
files were bigger) were copied. currently df shows

rootfs                 5044188   4310972    476980  91% /  <= file
system that is 'full'
/dev/root              5044188   4310972    476980  91% /
rc-svcdir                 1024       132       892  13% /lib/rc/init.d
udev                     10240        68     10172   1% /dev
cachedir                  4096         4      4092   1% /lib/splash/cache
none                    776940         4    776936   1% /dev/shm
/dev/hda3             24416008  22546040   1869968  93% /opt
/dev/hda6             11560764   9300396   1673112  85% /home
tmpfs                   776940      1728    775212   1% /tmp
tmpfs                  1331200        36   1331164   1% /var/tmp
tmpfs                 11560764   9300396   1673112  85% /usr/portage/distfiles

i like to use that last 470MB if possible

i also inclunded my tune2fs info

fsck didn't help (tried that)

--0016367659ebfc6b260460fed77e
Content-Type: application/octet-stream; name="tune2fs.dump"
Content-Disposition: attachment; filename="tune2fs.dump"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq82yuot0

dHVuZTJmcyAxLjQxLjMgKDEyLU9jdC0yMDA4KQpGaWxlc3lzdGVtIHZvbHVtZSBuYW1lOiAgIDxu
b25lPgpMYXN0IG1vdW50ZWQgb246ICAgICAgICAgIDxub3QgYXZhaWxhYmxlPgpGaWxlc3lzdGVt
IFVVSUQ6ICAgICAgICAgIGJkOGRhNTc3LTdiNTgtNDViYy05Yzk0LTgyNTRmNzE4ZTU1YQpGaWxl
c3lzdGVtIG1hZ2ljIG51bWJlcjogIDB4RUY1MwpGaWxlc3lzdGVtIHJldmlzaW9uICM6ICAgIDEg
KGR5bmFtaWMpCkZpbGVzeXN0ZW0gZmVhdHVyZXM6ICAgICAgaGFzX2pvdXJuYWwgZXh0X2F0dHIg
cmVzaXplX2lub2RlIGRpcl9pbmRleCBmaWxldHlwZSBuZWVkc19yZWNvdmVyeSBleHRlbnQgZmxl
eF9iZyBzcGFyc2Vfc3VwZXIgbGFyZ2VfZmlsZSBodWdlX2ZpbGUgdW5pbml0X2JnIGRpcl9ubGlu
ayBleHRyYV9pc2l6ZQpGaWxlc3lzdGVtIGZsYWdzOiAgICAgICAgIHNpZ25lZF9kaXJlY3Rvcnlf
aGFzaCAKRGVmYXVsdCBtb3VudCBvcHRpb25zOiAgICAobm9uZSkKRmlsZXN5c3RlbSBzdGF0ZTog
ICAgICAgICBjbGVhbgpFcnJvcnMgYmVoYXZpb3I6ICAgICAgICAgIENvbnRpbnVlCkZpbGVzeXN0
ZW0gT1MgdHlwZTogICAgICAgTGludXgKSW5vZGUgY291bnQ6ICAgICAgICAgICAgICAzMjA2NDAK
QmxvY2sgY291bnQ6ICAgICAgICAgICAgICAxMjgxMTgzClJlc2VydmVkIGJsb2NrIGNvdW50OiAg
ICAgNjQwNTkKRnJlZSBibG9ja3M6ICAgICAgICAgICAgICAxODMzMDQKRnJlZSBpbm9kZXM6ICAg
ICAgICAgICAgICA1OTU5MApGaXJzdCBibG9jazogICAgICAgICAgICAgIDAKQmxvY2sgc2l6ZTog
ICAgICAgICAgICAgICA0MDk2CkZyYWdtZW50IHNpemU6ICAgICAgICAgICAgNDA5NgpSZXNlcnZl
ZCBHRFQgYmxvY2tzOiAgICAgIDMxMgpCbG9ja3MgcGVyIGdyb3VwOiAgICAgICAgIDMyNzY4CkZy
YWdtZW50cyBwZXIgZ3JvdXA6ICAgICAgMzI3NjgKSW5vZGVzIHBlciBncm91cDogICAgICAgICA4
MDE2Cklub2RlIGJsb2NrcyBwZXIgZ3JvdXA6ICAgNTAxCkZsZXggYmxvY2sgZ3JvdXAgc2l6ZTog
ICAgMTYKRmlsZXN5c3RlbSBjcmVhdGVkOiAgICAgICBUdWUgSmFuIDIwIDE1OjI5OjU4IDIwMDkK
TGFzdCBtb3VudCB0aW1lOiAgICAgICAgICBXZWQgSmFuIDIxIDE1OjE5OjQxIDIwMDkKTGFzdCB3
cml0ZSB0aW1lOiAgICAgICAgICBXZWQgSmFuIDIxIDE1OjE5OjQxIDIwMDkKTW91bnQgY291bnQ6
ICAgICAgICAgICAgICA3Ck1heGltdW0gbW91bnQgY291bnQ6ICAgICAgMzAKTGFzdCBjaGVja2Vk
OiAgICAgICAgICAgICBXZWQgSmFuIDIxIDAwOjQ5OjUwIDIwMDkKQ2hlY2sgaW50ZXJ2YWw6ICAg
ICAgICAgICAxNTU1MjAwMCAoNiBtb250aHMpCk5leHQgY2hlY2sgYWZ0ZXI6ICAgICAgICAgTW9u
IEp1bCAyMCAwMTo0OTo1MCAyMDA5ClJlc2VydmVkIGJsb2NrcyB1aWQ6ICAgICAgMCAodXNlciBy
b290KQpSZXNlcnZlZCBibG9ja3MgZ2lkOiAgICAgIDAgKGdyb3VwIHJvb3QpCkZpcnN0IGlub2Rl
OiAgICAgICAgICAgICAgMTEKSW5vZGUgc2l6ZToJICAgICAgICAgIDI1NgpSZXF1aXJlZCBleHRy
YSBpc2l6ZTogICAgIDI4CkRlc2lyZWQgZXh0cmEgaXNpemU6ICAgICAgMjgKSm91cm5hbCBpbm9k
ZTogICAgICAgICAgICA4CkRlZmF1bHQgZGlyZWN0b3J5IGhhc2g6ICAgaGFsZl9tZDQKRGlyZWN0
b3J5IEhhc2ggU2VlZDogICAgICAwNGRmOThmYS01ODUxLTRmMjQtYjIzMi1jOGI0NzM4YWVmMGYK
Sm91cm5hbCBiYWNrdXA6ICAgICAgICAgICBpbm9kZSBibG9ja3MK
--0016367659ebfc6b260460fed77e--
