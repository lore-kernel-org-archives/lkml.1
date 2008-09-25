Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYIYHPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYIYHPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYIYHPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:15:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.112.145]:2976 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYIYHPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:15:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 25 Sep 2008 00:14:54 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
Date: Thu, 25 Sep 2008 15:14:50 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B33942E5A@hkemmail01.nvidia.com>
In-Reply-To: <s5hljxky01t.wl%tiwai@suse.de>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
thread-index: Ackcmc2LGBktJRkvTPOCsdSgUiyNnQCQ0u8w
References: <200809031558156739794@gmail.com><s5hhc8xpq6z.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B31F8F744@hkemmail01.nvidia.com><s5h4p4xph6x.wl%tiwai@suse.de><48BE7EE4.8020800@insite.cz><s5h63ouvpfc.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B3332408C@hkemmail01.nvidia.com> <s5hljxky01t.wl%tiwai@suse.de>
From: "Wei Ni" <wni@nvidia.com>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "peerchen" <peerchen@gmail.com>, "Pavel Hofman" <pavel.hofman@insite.cz>,
       "Peer Chen" <pchen@nvidia.com>,
       "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 25 Sep 2008 07:14:54.0448 (UTC) FILETIME=[68AC8700:01C91EDE]
Content-class: urn:content-classes:message
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C91EDE.66F6FDF6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C91EDE.66F6FDF6
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, Takashi
I use git to generate patches. (I run git-fetch origin, git-fetch-rebase
origin, and git-format-patch origin)

There are two patch, one for the addition of HDMI, and one for the fix
for our aza controller.

Please check it.

Thanks

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de]=20
Sent: Monday, September 22, 2008 5:58 PM
To: Wei Ni
Cc: peerchen; Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
Subject: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor
MCP77/79

At Mon, 22 Sep 2008 14:33:58 +0800,
Wei Ni wrote:
>=20
> Hi, Takashi
>=20
> About the "long delay", it seemed that we need to add this "delay" to
> fix some issue on our aza controller.
> Because it related with the controller, not just codec, so I think
this
> flag should not be added in codec-initialization part.
> I think it's better to add the flag in that place which I submitted.

OK, then could you split the patch to separate ones, i.e. one for the
fix for this problem regarding Nvidia controller chip, and one for the
addition of HDMI?

Don't forget to add a proper description for each patch, please ;)

As mentioned, that flag is a last resort, and I think it can be fixed
in a saner way.  But, the flag is surely safe, and we can track down
the problem later on.


thanks,

Takashi


>=20
> Thanks
>=20
> -----Original Message-----
> From: Wei Ni=20
> Sent: Friday, September 19, 2008 12:43 PM
> To: 'Takashi Iwai'; peerchen
> Cc: Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
> Subject: RE: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor
> MCP77/79
>=20
> Thanks for your reply.
>=20
> About the "long delay", we had some problems on reading RIRB buffer
when
> testing this driver, so we add this "delay"
> We will try to find a best way to fix this issue.
>=20
> And we didn't familiar with git, we will research it more such as
> "rebase" and then submit the patch file again.
>=20
> Thanks
>=20
> -----Original Message-----
> From: Takashi Iwai [mailto:tiwai@suse.de]=20
> Sent: Wednesday, September 17, 2008 10:05 PM
> To: peerchen
> Cc: Wei Ni; Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
> Subject: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor
> MCP77/79
>=20
> At Wed, 17 Sep 2008 17:00:04 +0800,
> peerchen wrote:
> >=20
> > new patch base on git tree.
> >=20
> > Signed-off-by: Wei Ni <wni@nvidia.com>
> > Signed-off-by: Peer Chen <peerchen@gmail.com>
>=20
> Thanks!
>=20
> But, the patch looks like no "rebase".  You secretly added a new
> function call that wasn't in your previous patch, namely...
>=20
> > diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff
> linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c
> linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c
> > --- linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c	2008-09-10
> 17:40:52.000000000 +0800
> > +++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c
> 2008-09-10 17:49:31.000000000 +0800
> > @@ -1220,6 +1220,9 @@ static int __devinit azx_codec_create(st
> >  	if (err < 0)
> >  		return err;
> > =20
> > +	if (chip->driver_type =3D=3D AZX_DRIVER_NVIDIA)
> > +		chip->bus->needs_damn_long_delay =3D 1;
> > +
>=20
> Do we really need this inevitably?  I don't think so -- otherwise I
> would have far more bug reports.
>=20
> This flag is the last resort and should be avoided as much as
> possible.  This results in a significant slow down of suspend/resume
> speed, for example.
>=20
> If it's really needed with some devices and there is no other way to
> fix it, add this flag rather in the codec-initialization part.
>=20
> Also, if you resend a patch, please add the original patch description

> again.  This helps my patch work a lot indeed.
>=20
>=20
> thanks,
>=20
> Takashi
>
------------------------------------------------------------------------
-----------
> This email message is for the sole use of the intended recipient(s)
and may contain
> confidential information.  Any unauthorized review, use, disclosure or
distribution
> is prohibited.  If you are not the intended recipient, please contact
the sender by
> reply email and destroy all copies of the original message.
>
------------------------------------------------------------------------
-----------
>=20

------_=_NextPart_001_01C91EDE.66F6FDF6
Content-Type: application/octet-stream;
	name="0001-Support-NVIDIA-MCP78-HDMI-audio.patch"
Content-Transfer-Encoding: base64
Content-Description: 0001-Support-NVIDIA-MCP78-HDMI-audio.patch
Content-Disposition: attachment;
	filename="0001-Support-NVIDIA-MCP78-HDMI-audio.patch"

RnJvbSBkZjhhYWI1M2M1MWY0YjI4NWRmYzIyZjZlZTFmOTgyZjZlODFhMzc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiByb290IDxyb290QG5pd2VpLmxpbnV4MT4KRGF0ZTogVGh1LCAy
NSBTZXAgMjAwOCAxNDo0OTo1NCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIFN1cHBvcnQgTlZJRElB
IE1DUDc4IEhETUkgYXVkaW8KCi0tLQogc291bmQvcGNpL0tjb25maWcgICAgICAgICAgICB8ICAg
IDggKysKIHNvdW5kL3BjaS9oZGEvTWFrZWZpbGUgICAgICAgfCAgICAxICsKIHNvdW5kL3BjaS9o
ZGEvaGRhX2NvZGVjLmMgICAgfCAgICAzICsKIHNvdW5kL3BjaS9oZGEvaGRhX3BhdGNoLmggICAg
fCAgICAyICsKIHNvdW5kL3BjaS9oZGEvcGF0Y2hfbnZoZG1pLmMgfCAgMTY0ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogNSBmaWxlcyBjaGFuZ2VkLCAxNzggaW5z
ZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBzb3VuZC9wY2kv
aGRhL3BhdGNoX252aGRtaS5jCgpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL0tjb25maWcgYi9zb3Vu
ZC9wY2kvS2NvbmZpZwppbmRleCAxZjhiNzk2Li43MDAzNzExIDEwMDY0NAotLS0gYS9zb3VuZC9w
Y2kvS2NvbmZpZworKysgYi9zb3VuZC9wY2kvS2NvbmZpZwpAQCAtNTY1LDYgKzU2NSwxNCBAQCBj
b25maWcgU05EX0hEQV9DT0RFQ19BVElIRE1JCiAJICBTYXkgWSBoZXJlIHRvIGluY2x1ZGUgQVRJ
IEhETUkgSEQtYXVkaW8gY29kZWMgc3VwcG9ydCBpbgogCSAgc25kLWhkYS1pbnRlbCBkcml2ZXIs
IHN1Y2ggYXMgQVRJIFJTNjAwIEhETUkuCiAKK2NvbmZpZyBTTkRfSERBX0NPREVDX05WSERNSQor
CWJvb2wgIkJ1aWxkIE5WSURJQSBIRE1JIEhELWF1ZGlvIGNvZGVjIHN1cHBvcnQiCisJZGVwZW5k
cyBvbiBTTkRfSERBX0lOVEVMCisJZGVmYXVsdCB5CisJaGVscAorCSAgU2F5IFkgaGVyZSB0byBp
bmNsdWRlIE5WSURJQSBIRE1JIEhELWF1ZGlvIGNvZGVjIHN1cHBvcnQgaW4KKwkgIHNuZC1oZGEt
aW50ZWwgZHJpdmVyLCBzdWNoIGFzIE5WSURJQSBNQ1A3OCBIRE1JLgorCiBjb25maWcgU05EX0hE
QV9DT0RFQ19DT05FWEFOVAogCWJvb2wgIkJ1aWxkIENvbmV4YW50IEhELWF1ZGlvIGNvZGVjIHN1
cHBvcnQiCiAJZGVwZW5kcyBvbiBTTkRfSERBX0lOVEVMCmRpZmYgLS1naXQgYS9zb3VuZC9wY2kv
aGRhL01ha2VmaWxlIGIvc291bmQvcGNpL2hkYS9NYWtlZmlsZQppbmRleCA2ZGI5MmZkLi4xOTgw
YzZkIDEwMDY0NAotLS0gYS9zb3VuZC9wY2kvaGRhL01ha2VmaWxlCisrKyBiL3NvdW5kL3BjaS9o
ZGEvTWFrZWZpbGUKQEAgLTE1LDUgKzE1LDYgQEAgc25kLWhkYS1pbnRlbC0kKENPTkZJR19TTkRf
SERBX0NPREVDX1NJMzA1NCkgKz0gcGF0Y2hfc2kzMDU0Lm8KIHNuZC1oZGEtaW50ZWwtJChDT05G
SUdfU05EX0hEQV9DT0RFQ19BVElIRE1JKSArPSBwYXRjaF9hdGloZG1pLm8KIHNuZC1oZGEtaW50
ZWwtJChDT05GSUdfU05EX0hEQV9DT0RFQ19DT05FWEFOVCkgKz0gcGF0Y2hfY29uZXhhbnQubwog
c25kLWhkYS1pbnRlbC0kKENPTkZJR19TTkRfSERBX0NPREVDX1ZJQSkgKz0gcGF0Y2hfdmlhLm8K
K3NuZC1oZGEtaW50ZWwtJChDT05GSUdfU05EX0hEQV9DT0RFQ19OVkhETUkpICs9IHBhdGNoX252
aGRtaS5vCiAKIG9iai0kKENPTkZJR19TTkRfSERBX0lOVEVMKSArPSBzbmQtaGRhLWludGVsLm8K
ZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvaGRhX2NvZGVjLmMgYi9zb3VuZC9wY2kvaGRhL2hk
YV9jb2RlYy5jCmluZGV4IGM3NDJlMTAuLjBkYTNhNjQgMTAwNjQ0Ci0tLSBhL3NvdW5kL3BjaS9o
ZGEvaGRhX2NvZGVjLmMKKysrIGIvc291bmQvcGNpL2hkYS9oZGFfY29kZWMuYwpAQCAtOTQsNiAr
OTQsOSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGhkYV9jb2RlY19wcmVzZXQgKmhkYV9wcmVzZXRf
dGFibGVzW10gPSB7CiAjaWZkZWYgQ09ORklHX1NORF9IREFfQ09ERUNfVklBCiAJc25kX2hkYV9w
cmVzZXRfdmlhLAogI2VuZGlmCisjaWZkZWYgQ09ORklHX1NORF9IREFfQ09ERUNfTlZIRE1JCisJ
c25kX2hkYV9wcmVzZXRfbnZoZG1pLAorI2VuZGlmCiAJTlVMTAogfTsKIApkaWZmIC0tZ2l0IGEv
c291bmQvcGNpL2hkYS9oZGFfcGF0Y2guaCBiL3NvdW5kL3BjaS9oZGEvaGRhX3BhdGNoLmgKaW5k
ZXggMmZkZjIzNS4uZGZiY2ZhOCAxMDA2NDQKLS0tIGEvc291bmQvcGNpL2hkYS9oZGFfcGF0Y2gu
aAorKysgYi9zb3VuZC9wY2kvaGRhL2hkYV9wYXRjaC5oCkBAIC0xOCwzICsxOCw1IEBAIGV4dGVy
biBzdHJ1Y3QgaGRhX2NvZGVjX3ByZXNldCBzbmRfaGRhX3ByZXNldF9hdGloZG1pW107CiBleHRl
cm4gc3RydWN0IGhkYV9jb2RlY19wcmVzZXQgc25kX2hkYV9wcmVzZXRfY29uZXhhbnRbXTsKIC8q
IFZJQSBjb2RlY3MgKi8KIGV4dGVybiBzdHJ1Y3QgaGRhX2NvZGVjX3ByZXNldCBzbmRfaGRhX3By
ZXNldF92aWFbXTsKKy8qIE5WSURJQSBIRE1JIGNvZGVjcyAqLworZXh0ZXJuIHN0cnVjdCBoZGFf
Y29kZWNfcHJlc2V0IHNuZF9oZGFfcHJlc2V0X252aGRtaVtdOwpkaWZmIC0tZ2l0IGEvc291bmQv
cGNpL2hkYS9wYXRjaF9udmhkbWkuYyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfbnZoZG1pLmMKbmV3
IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uZDBmZGQ1ZAotLS0gL2Rldi9udWxsCisr
KyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfbnZoZG1pLmMKQEAgLTAsMCArMSwxNjQgQEAKKy8qCisg
KiBVbml2ZXJzYWwgSW50ZXJmYWNlIGZvciBJbnRlbCBIaWdoIERlZmluaXRpb24gQXVkaW8gQ29k
ZWMKKyAqCisgKiBIRCBhdWRpbyBpbnRlcmZhY2UgcGF0Y2ggZm9yIE5WSURJQSBIRE1JIGNvZGVj
cworICoKKyAqIENvcHlyaWdodCAoYykgMjAwOCBOVklESUEgQ29ycC4gIEFsbCByaWdodHMgcmVz
ZXJ2ZWQuCisgKiBDb3B5cmlnaHQgKGMpIDIwMDggV2VpIE5pIDx3bmlAbnZpZGlhLmNvbT4KKyAq
CisgKgorICogIFRoaXMgZHJpdmVyIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmli
dXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQorICogIHRoZSBGcmVlIFNvZnR3
YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yCisgKiAg
KGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KKyAqCisgKiAgVGhpcyBkcml2ZXIg
aXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKKyAqICBi
dXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50
eSBvZgorICogIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVS
UE9TRS4gIFNlZSB0aGUKKyAqICBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBk
ZXRhaWxzLgorICoKKyAqICBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICogIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBp
ZiBub3QsIHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3YXJlCisgKiAgRm91bmRhdGlvbiwgSW5jLiwg
NTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgIDAyMTExLTEzMDcgVVNBCisg
Ki8KKworI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgor
I2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxzb3VuZC9jb3JlLmg+CisjaW5jbHVk
ZSAiaGRhX2NvZGVjLmgiCisjaW5jbHVkZSAiaGRhX2xvY2FsLmgiCisKK3N0cnVjdCBudmhkbWlf
c3BlYyB7CisJc3RydWN0IGhkYV9tdWx0aV9vdXQgbXVsdGlvdXQ7CisKKwlzdHJ1Y3QgaGRhX3Bj
bSBwY21fcmVjOworfTsKKworc3RhdGljIHN0cnVjdCBoZGFfdmVyYiBudmhkbWlfYmFzaWNfaW5p
dFtdID0geworCS8qIGVuYWJsZSBkaWdpdGFsIG91dHB1dCBvbiBwaW4gd2lkZ2V0ICovCisJeyAw
eDA1LCBBQ19WRVJCX1NFVF9QSU5fV0lER0VUX0NPTlRST0wsIFBJTl9PVVQgfSwKKwl7fSAvKiB0
ZXJtaW5hdG9yICovCit9OworCisvKgorICogQ29udHJvbHMKKyAqLworc3RhdGljIGludCBudmhk
bWlfYnVpbGRfY29udHJvbHMoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpCit7CisJc3RydWN0IG52
aGRtaV9zcGVjICpzcGVjID0gY29kZWMtPnNwZWM7CisJaW50IGVycjsKKworCWVyciA9IHNuZF9o
ZGFfY3JlYXRlX3NwZGlmX291dF9jdGxzKGNvZGVjLCBzcGVjLT5tdWx0aW91dC5kaWdfb3V0X25p
ZCk7CisJaWYgKGVyciA8IDApCisJCXJldHVybiBlcnI7CisKKwlyZXR1cm4gMDsKK30KKworc3Rh
dGljIGludCBudmhkbWlfaW5pdChzdHJ1Y3QgaGRhX2NvZGVjICpjb2RlYykKK3sKKwlzbmRfaGRh
X3NlcXVlbmNlX3dyaXRlKGNvZGVjLCBudmhkbWlfYmFzaWNfaW5pdCk7CisJcmV0dXJuIDA7Cit9
CisKKy8qCisgKiBEaWdpdGFsIG91dAorICovCitzdGF0aWMgaW50IG52aGRtaV9kaWdfcGxheWJh
Y2tfcGNtX29wZW4oc3RydWN0IGhkYV9wY21fc3RyZWFtICpoaW5mbywKKwkJCQkgICAgIHN0cnVj
dCBoZGFfY29kZWMgKmNvZGVjLAorCQkJCSAgICAgc3RydWN0IHNuZF9wY21fc3Vic3RyZWFtICpz
dWJzdHJlYW0pCit7CisJc3RydWN0IG52aGRtaV9zcGVjICpzcGVjID0gY29kZWMtPnNwZWM7CisJ
cmV0dXJuIHNuZF9oZGFfbXVsdGlfb3V0X2RpZ19vcGVuKGNvZGVjLCAmc3BlYy0+bXVsdGlvdXQp
OworfQorCitzdGF0aWMgaW50IG52aGRtaV9kaWdfcGxheWJhY2tfcGNtX2Nsb3NlKHN0cnVjdCBo
ZGFfcGNtX3N0cmVhbSAqaGluZm8sCisJCQkJICAgICAgc3RydWN0IGhkYV9jb2RlYyAqY29kZWMs
CisJCQkJICAgICAgc3RydWN0IHNuZF9wY21fc3Vic3RyZWFtICpzdWJzdHJlYW0pCit7CisJc3Ry
dWN0IG52aGRtaV9zcGVjICpzcGVjID0gY29kZWMtPnNwZWM7CisJcmV0dXJuIHNuZF9oZGFfbXVs
dGlfb3V0X2RpZ19jbG9zZShjb2RlYywgJnNwZWMtPm11bHRpb3V0KTsKK30KKworc3RhdGljIGlu
dCBudmhkbWlfZGlnX3BsYXliYWNrX3BjbV9wcmVwYXJlKHN0cnVjdCBoZGFfcGNtX3N0cmVhbSAq
aGluZm8sCisJCQkJCSAgICBzdHJ1Y3QgaGRhX2NvZGVjICpjb2RlYywKKwkJCQkJICAgIHVuc2ln
bmVkIGludCBzdHJlYW1fdGFnLAorCQkJCQkgICAgdW5zaWduZWQgaW50IGZvcm1hdCwKKwkJCQkJ
ICAgIHN0cnVjdCBzbmRfcGNtX3N1YnN0cmVhbSAqc3Vic3RyZWFtKQoreworCXN0cnVjdCBudmhk
bWlfc3BlYyAqc3BlYyA9IGNvZGVjLT5zcGVjOworCXJldHVybiBzbmRfaGRhX211bHRpX291dF9k
aWdfcHJlcGFyZShjb2RlYywgJnNwZWMtPm11bHRpb3V0LCBzdHJlYW1fdGFnLAorCQkJCQkgICAg
IGZvcm1hdCwgc3Vic3RyZWFtKTsKK30KKworc3RhdGljIHN0cnVjdCBoZGFfcGNtX3N0cmVhbSBu
dmhkbWlfcGNtX2RpZ2l0YWxfcGxheWJhY2sgPSB7CisJLnN1YnN0cmVhbXMgPSAxLAorCS5jaGFu
bmVsc19taW4gPSAyLAorCS5jaGFubmVsc19tYXggPSAyLAorCS5uaWQgPSAweDQsIC8qIE5JRCB0
byBxdWVyeSBmb3JtYXRzIGFuZCByYXRlcyBhbmQgc2V0dXAgc3RyZWFtcyAqLworICAgICAgICAu
cmF0ZXMgPSBTTkRSVl9QQ01fUkFURV80ODAwMCwKKyAgICAgICAgLm1heGJwcyA9IDE2LAorICAg
ICAgICAuZm9ybWF0cyA9IFNORFJWX1BDTV9GTVRCSVRfUzE2X0xFLAorCS5vcHMgPSB7CisJCS5v
cGVuID0gbnZoZG1pX2RpZ19wbGF5YmFja19wY21fb3BlbiwKKwkJLmNsb3NlID0gbnZoZG1pX2Rp
Z19wbGF5YmFja19wY21fY2xvc2UsCisJCS5wcmVwYXJlID0gbnZoZG1pX2RpZ19wbGF5YmFja19w
Y21fcHJlcGFyZQorCX0sCit9OworCitzdGF0aWMgaW50IG52aGRtaV9idWlsZF9wY21zKHN0cnVj
dCBoZGFfY29kZWMgKmNvZGVjKQoreworCXN0cnVjdCBudmhkbWlfc3BlYyAqc3BlYyA9IGNvZGVj
LT5zcGVjOworCXN0cnVjdCBoZGFfcGNtICppbmZvID0gJnNwZWMtPnBjbV9yZWM7CisKKwljb2Rl
Yy0+bnVtX3BjbXMgPSAxOworCWNvZGVjLT5wY21faW5mbyA9IGluZm87CisKKwlpbmZvLT5uYW1l
ID0gIk5WSURJQSBIRE1JIjsKKwlpbmZvLT5zdHJlYW1bU05EUlZfUENNX1NUUkVBTV9QTEFZQkFD
S10gPSBudmhkbWlfcGNtX2RpZ2l0YWxfcGxheWJhY2s7CisKKwlyZXR1cm4gMDsKK30KKworc3Rh
dGljIHZvaWQgbnZoZG1pX2ZyZWUoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpCit7CisJa2ZyZWUo
Y29kZWMtPnNwZWMpOworfQorCitzdGF0aWMgc3RydWN0IGhkYV9jb2RlY19vcHMgbnZoZG1pX3Bh
dGNoX29wcyA9IHsKKwkuYnVpbGRfY29udHJvbHMgPSBudmhkbWlfYnVpbGRfY29udHJvbHMsCisJ
LmJ1aWxkX3BjbXMgPSBudmhkbWlfYnVpbGRfcGNtcywKKwkuaW5pdCA9IG52aGRtaV9pbml0LAor
CS5mcmVlID0gbnZoZG1pX2ZyZWUsCit9OworCitzdGF0aWMgaW50IHBhdGNoX252aGRtaShzdHJ1
Y3QgaGRhX2NvZGVjICpjb2RlYykKK3sKKwlzdHJ1Y3QgbnZoZG1pX3NwZWMgKnNwZWM7CisKKwlz
cGVjID0ga3phbGxvYyhzaXplb2YoKnNwZWMpLCBHRlBfS0VSTkVMKTsKKwlpZiAoc3BlYyA9PSBO
VUxMKQorCQlyZXR1cm4gLUVOT01FTTsKKworCWNvZGVjLT5zcGVjID0gc3BlYzsKKworCXNwZWMt
Pm11bHRpb3V0Lm51bV9kYWNzID0gMDsJICAvKiBubyBhbmFsb2cgKi8KKwlzcGVjLT5tdWx0aW91
dC5tYXhfY2hhbm5lbHMgPSAyOworCXNwZWMtPm11bHRpb3V0LmRpZ19vdXRfbmlkID0gMHg0OyAv
KiBOSUQgZm9yIGNvcHlpbmcgYW5hbG9nIHRvIGRpZ2l0YWwsCisJCQkJCSAgICogc2VlbXMgdG8g
YmUgdW51c2VkIGluIHB1cmUtZGlnaXRhbAorCQkJCQkgICAqIGNhc2UuICovCisKKwljb2RlYy0+
cGF0Y2hfb3BzID0gbnZoZG1pX3BhdGNoX29wczsKKworCXJldHVybiAwOworfQorCisvKgorICog
cGF0Y2ggZW50cmllcworICovCitzdHJ1Y3QgaGRhX2NvZGVjX3ByZXNldCBzbmRfaGRhX3ByZXNl
dF9udmhkbWlbXSA9IHsKKwl7IC5pZCA9IDB4MTBkZTAwMDIsIC5uYW1lID0gIk5WSURJQSBNQ1A3
OCBIRE1JIiwgLnBhdGNoID0gcGF0Y2hfbnZoZG1pIH0sCisJeyAuaWQgPSAweDEwZGUwMDA3LCAu
bmFtZSA9ICJOVklESUEgTUNQN0EgSERNSSIsIC5wYXRjaCA9IHBhdGNoX252aGRtaSB9LAorCXt9
IC8qIHRlcm1pbmF0b3IgKi8KK307Ci0tIAoxLjUuNgoK

------_=_NextPart_001_01C91EDE.66F6FDF6
Content-Type: application/octet-stream;
	name="0002-Fix-for-reading-RIRB-buffer-on-NVIDIA-aza-controller.patch"
Content-Transfer-Encoding: base64
Content-Description: 0002-Fix-for-reading-RIRB-buffer-on-NVIDIA-aza-controller.patch
Content-Disposition: attachment;
	filename="0002-Fix-for-reading-RIRB-buffer-on-NVIDIA-aza-controller.patch"

RnJvbSAyYjlhMWU2MmI5Y2U1OTk3MDNkN2RkNzNhMGRmNWQ4MmU5NDgyYTMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiByb290IDxyb290QG5pd2VpLmxpbnV4MT4KRGF0ZTogVGh1LCAy
NSBTZXAgMjAwOCAxNDo1NjoyOCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIEZpeCBmb3IgcmVhZGlu
ZyBSSVJCIGJ1ZmZlciBvbiBOVklESUEgYXphIGNvbnRyb2xsZXIKCi0tLQogc291bmQvcGNpL2hk
YS9oZGFfaW50ZWwuYyB8ICAgIDMgKysrCiAxIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9zb3VuZC9wY2kvaGRhL2hkYV9pbnRlbC5j
IGIvc291bmQvcGNpL2hkYS9oZGFfaW50ZWwuYwppbmRleCA2MGNjNDRhLi45ZjMxNmMxIDEwMDY0
NAotLS0gYS9zb3VuZC9wY2kvaGRhL2hkYV9pbnRlbC5jCisrKyBiL3NvdW5kL3BjaS9oZGEvaGRh
X2ludGVsLmMKQEAgLTEyMjAsNiArMTIyMCw5IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IGF6eF9j
b2RlY19jcmVhdGUoc3RydWN0IGF6eCAqY2hpcCwgY29uc3QgY2hhciAqbW9kZWwsCiAJaWYgKGVy
ciA8IDApCiAJCXJldHVybiBlcnI7CiAKKwlpZiAoY2hpcC0+ZHJpdmVyX3R5cGUgPT0gQVpYX0RS
SVZFUl9OVklESUEpCisJCWNoaXAtPmJ1cy0+bmVlZHNfZGFtbl9sb25nX2RlbGF5ID0gMTsKKwog
CWNvZGVjcyA9IGF1ZGlvX2NvZGVjcyA9IDA7CiAJbWF4X3Nsb3RzID0gYXp4X21heF9jb2RlY3Nb
Y2hpcC0+ZHJpdmVyX3R5cGVdOwogCWlmICghbWF4X3Nsb3RzKQotLSAKMS41LjYKCg==

------_=_NextPart_001_01C91EDE.66F6FDF6--
