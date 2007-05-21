Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbXEUIJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbXEUIJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXEUIJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:09:18 -0400
Received: from nn7.de ([85.214.94.156]:41289 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbXEUIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:09:16 -0400
Subject: applesmc - sensors patch missing from 2.6.22-rc2
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Content-Type: multipart/mixed; boundary="=-suVYLAbaNooOeTALddLE"
Date: Mon, 21 May 2007 10:09:13 +0200
Message-Id: <1179734953.4487.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-suVYLAbaNooOeTALddLE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

I wonder why the attached patch is missing from applesmc (written by
nicolas boichat) without which sensors simply won't work ...

( but these ones has been applied and are rather useless without the
attached one
http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg12374.html
http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg12371.html =
)


I am using this for some weeks on 2.6.21 now without problems

$ sensors
applesmc-isa-0300
Adapter: ISA adapter
temp1:       +28=B0C
temp2:       +40=B0C
temp3:       +66=B0C
temp4:       +58=B0C
temp5:       +65=B0C
temp6:       +62=B0C
temp7:       +69=B0C
temp8:       +49=B0C
temp9:       +45=B0C
temp10:      +58=B0C
temp11:      +40=B0C
temp12:      +39=B0C
fan1:     1060 RPM (safe =3D 1200 RPM, min =3D 1000 RPM, max =3D 6000 RPM)
fan2:     1060 RPM (safe =3D 1200 RPM, min =3D 1000 RPM, max =3D 6000 RPM)

Soeren
--=20
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.

--=-suVYLAbaNooOeTALddLE
Content-Description: 
Content-Disposition: attachment; filename=applesmc.patch
Content-Type: text/x-patch; charset=ISO-8859-15
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vYXBwbGVzbWMuYyBiL2RyaXZlcnMvaHdtb24vYXBw
bGVzbWMuYw0KaW5kZXggMGMxNjA2Ny4uMzY2ZjRhMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaHdt
b24vYXBwbGVzbWMuYw0KKysrIGIvZHJpdmVycy9od21vbi9hcHBsZXNtYy5jDQpAQCAtNDkxLDYg
KzQ5MSwxMiBAQCBvdXQ6DQogDQogLyogU3lzZnMgRmlsZXMgKi8NCiANCitzdGF0aWMgc3NpemVf
dCBhcHBsZXNtY19uYW1lX3Nob3coc3RydWN0IGRldmljZSAqZGV2LA0KKwkJCQkgICBzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQ0KK3sNCisJcmV0dXJuIHNucHJpbnRm
KGJ1ZiwgUEFHRV9TSVpFLCAiYXBwbGVzbWNcbiIpOw0KK30NCisNCiBzdGF0aWMgc3NpemVfdCBh
cHBsZXNtY19wb3NpdGlvbl9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwNCiAJCQkJICAgc3RydWN0
IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikNCiB7DQpAQCAtOTEzLDYgKzkxOSw4
IEBAIHN0YXRpYyBzdHJ1Y3QgbGVkX2NsYXNzZGV2IGFwcGxlc21jX2JhY2tsaWdodCA9IHsNCiAJ
LmJyaWdodG5lc3Nfc2V0CQk9IGFwcGxlc21jX2JyaWdodG5lc3Nfc2V0LA0KIH07DQogDQorc3Rh
dGljIERFVklDRV9BVFRSKG5hbWUsIDA0NDQsIGFwcGxlc21jX25hbWVfc2hvdywgTlVMTCk7DQor
DQogc3RhdGljIERFVklDRV9BVFRSKHBvc2l0aW9uLCAwNDQ0LCBhcHBsZXNtY19wb3NpdGlvbl9z
aG93LCBOVUxMKTsNCiBzdGF0aWMgREVWSUNFX0FUVFIoY2FsaWJyYXRlLCAwNjQ0LA0KIAkJCWFw
cGxlc21jX2NhbGlicmF0ZV9zaG93LCBhcHBsZXNtY19jYWxpYnJhdGVfc3RvcmUpOw0KQEAgLTEx
OTcsNiArMTIwNSw4IEBAIHN0YXRpYyBpbnQgX19pbml0IGFwcGxlc21jX2luaXQodm9pZCkNCiAJ
CWdvdG8gb3V0X2RyaXZlcjsNCiAJfQ0KIA0KKwlyZXQgPSBzeXNmc19jcmVhdGVfZmlsZSgmcGRl
di0+ZGV2LmtvYmosICZkZXZfYXR0cl9uYW1lLmF0dHIpOw0KKw0KIAkvKiBDcmVhdGUga2V5IGVu
dW1lcmF0aW9uIHN5c2ZzIGZpbGVzICovDQogCXJldCA9IHN5c2ZzX2NyZWF0ZV9ncm91cCgmcGRl
di0+ZGV2LmtvYmosICZrZXlfZW51bWVyYXRpb25fZ3JvdXApOw0KIAlpZiAocmV0KQ0K


--=-suVYLAbaNooOeTALddLE--
