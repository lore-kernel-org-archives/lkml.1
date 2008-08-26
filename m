Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYHZQzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYHZQzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYHZQzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:55:04 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:46888 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbYHZQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:55:03 -0400
Message-ID: <48B43562.20602@numericable.fr>
Date: Tue, 26 Aug 2008 18:54:58 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008082610)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>
Subject: [2.6.27-rc4-git5] ipv4: sysctl fixes causes "cannot open /proc/sys/net/ipv4/route/flush"
Content-Type: multipart/mixed;
 boundary="------------080203000807050605080705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080203000807050605080705
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Al and David,


After building the fresh 2.6.27-rc4-git5 kernel with your patch in 
commit 2f4520d35d89ca6c5cd129c38e3b11f0283b7d1b, I have this error on boot :

> Cannot open "/proc/sys/net/ipv4/route/flush"
but networking works fine.

Do I modify something in my sysctl.conf file ? (see attached).

Thanks for your explanations,

Regards.




--------------080203000807050605080705
Content-Type: text/plain;
 name="sysctl.conf"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sysctl.conf"

IyAvZXRjL3N5c2N0bC5jb25mCiMKIyBGb3IgbW9yZSBpbmZvcm1hdGlvbiBvbiBob3cgdGhp
cyBmaWxlIHdvcmtzLCBwbGVhc2Ugc2VlCiMgdGhlIG1hbnBhZ2VzIHN5c2N0bCg4KSBhbmQg
c3lzY3RsLmNvbmYoNSkuCiMKIyBJbiBvcmRlciBmb3IgdGhpcyBmaWxlIHRvIHdvcmsgcHJv
cGVybHksIHlvdSBtdXN0IGZpcnN0CiMgZW5hYmxlICdTeXNjdGwgc3VwcG9ydCcgaW4gdGhl
IGtlcm5lbC4KIwojIExvb2sgaW4gL3Byb2Mvc3lzLyBmb3IgYWxsIHRoZSB0aGluZ3MgeW91
IGNhbiBzZXR1cC4KIwoKIyBEaXNhYmxlcyBwYWNrZXQgZm9yd2FyZGluZwpuZXQuaXB2NC5p
cF9mb3J3YXJkID0gMAojIERpc2FibGVzIElQIGR5bmFkZHIKI25ldC5pcHY0LmlwX2R5bmFk
ZHIgPSAwCiMgRGlzYWJsZSBFQ04KI25ldC5pcHY0LnRjcF9lY24gPSAwCiMgRW5hYmxlcyBz
b3VyY2Ugcm91dGUgdmVyaWZpY2F0aW9uCm5ldC5pcHY0LmNvbmYuZGVmYXVsdC5ycF9maWx0
ZXIgPSAxCiMgRW5hYmxlIHJldmVyc2UgcGF0aApuZXQuaXB2NC5jb25mLmFsbC5ycF9maWx0
ZXIgPSAxCgojIEVuYWJsZSBTWU4gY29va2llcyAoeXVtISkKIyBodHRwOi8vY3IueXAudG8v
c3luY29va2llcy5odG1sCm5ldC5pcHY0LnRjcF9zeW5jb29raWVzID0gMQoKIyBEaXNhYmxl
IHNvdXJjZSByb3V0ZQpuZXQuaXB2NC5jb25mLmFsbC5hY2NlcHRfc291cmNlX3JvdXRlID0g
MAojbmV0LmlwdjQuY29uZi5kZWZhdWx0LmFjY2VwdF9zb3VyY2Vfcm91dGUgPSAwCgojIERp
c2FibGUgcmVkaXJlY3RzCm5ldC5pcHY0LmNvbmYuYWxsLmFjY2VwdF9yZWRpcmVjdHMgPSAw
CiNuZXQuaXB2NC5jb25mLmRlZmF1bHQuYWNjZXB0X3JlZGlyZWN0cyA9IDAKCiMgRGlzYWJs
ZSBzZWN1cmUgcmVkaXJlY3RzCm5ldC5pcHY0LmNvbmYuYWxsLnNlY3VyZV9yZWRpcmVjdHMg
PSAwCiNuZXQuaXB2NC5jb25mLmRlZmF1bHQuc2VjdXJlX3JlZGlyZWN0cyA9IDAKCiMgSWdu
b3JlIElDTVAgYnJvYWRjYXN0cwpuZXQuaXB2NC5pY21wX2VjaG9faWdub3JlX2Jyb2FkY2Fz
dHMgPSAxCm5ldC5pcHY0LmljbXBfZWNob19pZ25vcmVfYWxsID0gMQpuZXQuaXB2NC5pY21w
X2lnbm9yZV9ib2d1c19lcnJvcl9yZXNwb25zZXMgPSAxCgojIERpc2FibGVzIHRoZSBtYWdp
Yy1zeXNycSBrZXkKI2tlcm5lbC5zeXNycSA9IDAKIyBXaGVuIHRoZSBrZXJuZWwgcGFuaWNz
LCBhdXRvbWF0aWNhbGx5IHJlYm9vdCBpbiAzIHNlY29uZHMKI2tlcm5lbC5wYW5pYyA9IDMK
IyBBbGxvdyBmb3IgbW9yZSBQSURzIChjb29sIGZhY3RvciEpOyBtYXkgYnJlYWsgc29tZSBw
cm9ncmFtcwoja2VybmVsLnBpZF9tYXggPSA5OTk5OTkKCiMgWW91IHNob3VsZCBjb21waWxl
IG5mc2QgaW50byB0aGUga2VybmVsIG9yIGFkZCBpdAojIHRvIG1vZHVsZXMuYXV0b2xvYWQg
Zm9yIHRoaXMgdG8gd29yayBwcm9wZXJseQojIFRDUCBQb3J0IGZvciBsb2NrIG1hbmFnZXIK
I2ZzLm5mcy5ubG1fdGNwcG9ydCA9IDAKIyBVRFAgUG9ydCBmb3IgbG9jayBtYW5hZ2VyCiNm
cy5uZnMubmxtX3VkcHBvcnQgPSAwCm5ldC5pcHY0LmNvbmYuYWxsLmxvZ19tYXJ0aWFucyA9
IDEK
--------------080203000807050605080705--
