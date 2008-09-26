Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYIZGUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYIZGUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYIZGUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:20:05 -0400
Received: from hqemgate03.nvidia.com ([216.228.112.145]:11876 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYIZGUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:20:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Thu, 25 Sep 2008 23:19:52 -0700
MIME-Version: 1.0
Subject: RE: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 26 Sep 2008 14:19:46 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B33AA75B6@hkemmail01.nvidia.com>
In-Reply-To: <s5h63oktur5.wl%tiwai@suse.de>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
Thread-Index: Acke9ORf9lPPGzn8SRWX6BcCGxagZwAqjXNg
References: <200809031558156739794@gmail.com><s5hhc8xpq6z.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B31F8F744@hkemmail01.nvidia.com><s5h4p4xph6x.wl%tiwai@suse.de><48BE7EE4.8020800@insite.cz><s5h63ouvpfc.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B3332408C@hkemmail01.nvidia.com><s5hljxky01t.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B33942E5A@hkemmail01.nvidia.com> <s5h63oktur5.wl%tiwai@suse.de>
From: "Wei Ni" <wni@nvidia.com>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "peerchen" <peerchen@gmail.com>, "Pavel Hofman" <pavel.hofman@insite.cz>,
       "Peer Chen" <pchen@nvidia.com>,
       "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 26 Sep 2008 06:19:51.0734 (UTC) FILETIME=[E2841D60:01C91F9F]
Content-class: urn:content-classes:message
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C91F9F.E0A3A584"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C91F9F.E0A3A584
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, Takashi
I fixed something based on your comments, please check the patch files.

Thanks

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de]=20
Sent: Thursday, September 25, 2008 5:55 PM
To: Wei Ni
Cc: peerchen; Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
Subject: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor
MCP77/79

At Thu, 25 Sep 2008 15:14:50 +0800,
Wei Ni wrote:
>=20
> Hi, Takashi
> I use git to generate patches. (I run git-fetch origin,
git-fetch-rebase
> origin, and git-format-patch origin)
>=20
> There are two patch, one for the addition of HDMI, and one for the fix
> for our aza controller.
>=20
> Please check it.

Thanks for patches.  It's good that you are using git now.
The code changes look good, but there are small issues in the patches:

- The author line is bogus.  Edit your ~/.gitconfig and add like the
  following:
	[user]
	  name =3D Wei Ni
	  email =3D wni@nvidia.com
  Then reset and commit patches again.

- Missing sign-off.  Add --sign option when you do git-commit.

- No proper change log.  Only a subject line isn't enough for many
  (most) cases, especially for a patch like workaround for nvidia
  controller.
  Please describe why this change is needed more precisely.

Could you fix and repost again?


Thanks!

Takashi


>=20
> Thanks
>=20
> -----Original Message-----
> From: Takashi Iwai [mailto:tiwai@suse.de]=20
> Sent: Monday, September 22, 2008 5:58 PM
> To: Wei Ni
> Cc: peerchen; Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
> Subject: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor
> MCP77/79
>=20
> At Mon, 22 Sep 2008 14:33:58 +0800,
> Wei Ni wrote:
> >=20
> > Hi, Takashi
> >=20
> > About the "long delay", it seemed that we need to add this "delay"
to
> > fix some issue on our aza controller.
> > Because it related with the controller, not just codec, so I think
> this
> > flag should not be added in codec-initialization part.
> > I think it's better to add the flag in that place which I submitted.
>=20
> OK, then could you split the patch to separate ones, i.e. one for the
> fix for this problem regarding Nvidia controller chip, and one for the
> addition of HDMI?
>=20
> Don't forget to add a proper description for each patch, please ;)
>=20
> As mentioned, that flag is a last resort, and I think it can be fixed
> in a saner way.  But, the flag is surely safe, and we can track down
> the problem later on.
>=20
>=20
> thanks,
>=20
> Takashi
>=20
>=20
> >=20
> > Thanks
> >=20
> > -----Original Message-----
> > From: Wei Ni=20
> > Sent: Friday, September 19, 2008 12:43 PM
> > To: 'Takashi Iwai'; peerchen
> > Cc: Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
> > Subject: RE: [alsa-devel] [PATCH] add the nvidia HDMI codec
driverfor
> > MCP77/79
> >=20
> > Thanks for your reply.
> >=20
> > About the "long delay", we had some problems on reading RIRB buffer
> when
> > testing this driver, so we add this "delay"
> > We will try to find a best way to fix this issue.
> >=20
> > And we didn't familiar with git, we will research it more such as
> > "rebase" and then submit the patch file again.
> >=20
> > Thanks
> >=20
> > -----Original Message-----
> > From: Takashi Iwai [mailto:tiwai@suse.de]=20
> > Sent: Wednesday, September 17, 2008 10:05 PM
> > To: peerchen
> > Cc: Wei Ni; Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
> > Subject: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec
driverfor
> > MCP77/79
> >=20
> > At Wed, 17 Sep 2008 17:00:04 +0800,
> > peerchen wrote:
> > >=20
> > > new patch base on git tree.
> > >=20
> > > Signed-off-by: Wei Ni <wni@nvidia.com>
> > > Signed-off-by: Peer Chen <peerchen@gmail.com>
> >=20
> > Thanks!
> >=20
> > But, the patch looks like no "rebase".  You secretly added a new
> > function call that wasn't in your previous patch, namely...
> >=20
> > > diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff
> > linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c
> > linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c
> > > --- linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c
2008-09-10
> > 17:40:52.000000000 +0800
> > > +++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c
> > 2008-09-10 17:49:31.000000000 +0800
> > > @@ -1220,6 +1220,9 @@ static int __devinit azx_codec_create(st
> > >  	if (err < 0)
> > >  		return err;
> > > =20
> > > +	if (chip->driver_type =3D=3D AZX_DRIVER_NVIDIA)
> > > +		chip->bus->needs_damn_long_delay =3D 1;
> > > +
> >=20
> > Do we really need this inevitably?  I don't think so -- otherwise I
> > would have far more bug reports.
> >=20
> > This flag is the last resort and should be avoided as much as
> > possible.  This results in a significant slow down of suspend/resume
> > speed, for example.
> >=20
> > If it's really needed with some devices and there is no other way to
> > fix it, add this flag rather in the codec-initialization part.
> >=20
> > Also, if you resend a patch, please add the original patch
description
>=20
> > again.  This helps my patch work a lot indeed.
> >=20
> >=20
> > thanks,
> >=20
> > Takashi
> >
>
------------------------------------------------------------------------
> -----------
> > This email message is for the sole use of the intended recipient(s)
> and may contain
> > confidential information.  Any unauthorized review, use, disclosure
or
> distribution
> > is prohibited.  If you are not the intended recipient, please
contact
> the sender by
> > reply email and destroy all copies of the original message.
> >
>
------------------------------------------------------------------------
> -----------
> >=20
> [2 0001-Support-NVIDIA-MCP78-HDMI-audio.patch
<application/octet-stream (base64)>]
>=20
> [3 0002-Fix-for-reading-RIRB-buffer-on-NVIDIA-aza-controller.patch
<application/octet-stream (base64)>]
>=20

------_=_NextPart_001_01C91F9F.E0A3A584
Content-Type: application/octet-stream;
	name="0001-Support-NVIDIA-MCP78-7A-HDMI-audio.patch"
Content-Transfer-Encoding: base64
Content-Description: 0001-Support-NVIDIA-MCP78-7A-HDMI-audio.patch
Content-Disposition: attachment;
	filename="0001-Support-NVIDIA-MCP78-7A-HDMI-audio.patch"

RnJvbSA5ODIyOTBkZjcwNzdjZWY0NGRjNmY3ZGNhNjc5YWU2YzZmODViOWJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXZWkgTmkgPHduaUBudmlkaWEuY29tPgpEYXRlOiBGcmksIDI2
IFNlcCAyMDA4IDEzOjQ1OjQ2ICswODAwClN1YmplY3Q6IFtQQVRDSF0gU3VwcG9ydCBOVklESUEg
TUNQNzgvN0EgSERNSSBhdWRpbwoKU2lnbmVkLW9mZi1ieTogV2VpIE5pIDx3bmlAbnZpZGlhLmNv
bT4KCkFkZCBOVklESUEgSERNSSBIRC1hdWRpbyBjb2RlYyBzdXBwb3J0IGluIHNuZC1oZGEtaW50
ZWwgZHJpdmVyLCBpbmNsdWRlIE5WSURJQSBNQ1A3OC83QSBIRE1JLgotLS0KIHNvdW5kL3BjaS9L
Y29uZmlnICAgICAgICAgICAgfCAgICA4ICsrCiBzb3VuZC9wY2kvaGRhL01ha2VmaWxlICAgICAg
IHwgICAgMSArCiBzb3VuZC9wY2kvaGRhL2hkYV9jb2RlYy5jICAgIHwgICAgMyArCiBzb3VuZC9w
Y2kvaGRhL2hkYV9wYXRjaC5oICAgIHwgICAgMiArCiBzb3VuZC9wY2kvaGRhL3BhdGNoX252aGRt
aS5jIHwgIDE2NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDUg
ZmlsZXMgY2hhbmdlZCwgMTc4IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCiBjcmVhdGUg
bW9kZSAxMDA2NDQgc291bmQvcGNpL2hkYS9wYXRjaF9udmhkbWkuYwoKZGlmZiAtLWdpdCBhL3Nv
dW5kL3BjaS9LY29uZmlnIGIvc291bmQvcGNpL0tjb25maWcKaW5kZXggMWY4Yjc5Ni4uNzAwMzcx
MSAxMDA2NDQKLS0tIGEvc291bmQvcGNpL0tjb25maWcKKysrIGIvc291bmQvcGNpL0tjb25maWcK
QEAgLTU2NSw2ICs1NjUsMTQgQEAgY29uZmlnIFNORF9IREFfQ09ERUNfQVRJSERNSQogCSAgU2F5
IFkgaGVyZSB0byBpbmNsdWRlIEFUSSBIRE1JIEhELWF1ZGlvIGNvZGVjIHN1cHBvcnQgaW4KIAkg
IHNuZC1oZGEtaW50ZWwgZHJpdmVyLCBzdWNoIGFzIEFUSSBSUzYwMCBIRE1JLgogCitjb25maWcg
U05EX0hEQV9DT0RFQ19OVkhETUkKKwlib29sICJCdWlsZCBOVklESUEgSERNSSBIRC1hdWRpbyBj
b2RlYyBzdXBwb3J0IgorCWRlcGVuZHMgb24gU05EX0hEQV9JTlRFTAorCWRlZmF1bHQgeQorCWhl
bHAKKwkgIFNheSBZIGhlcmUgdG8gaW5jbHVkZSBOVklESUEgSERNSSBIRC1hdWRpbyBjb2RlYyBz
dXBwb3J0IGluCisJICBzbmQtaGRhLWludGVsIGRyaXZlciwgc3VjaCBhcyBOVklESUEgTUNQNzgg
SERNSS4KKwogY29uZmlnIFNORF9IREFfQ09ERUNfQ09ORVhBTlQKIAlib29sICJCdWlsZCBDb25l
eGFudCBIRC1hdWRpbyBjb2RlYyBzdXBwb3J0IgogCWRlcGVuZHMgb24gU05EX0hEQV9JTlRFTApk
aWZmIC0tZ2l0IGEvc291bmQvcGNpL2hkYS9NYWtlZmlsZSBiL3NvdW5kL3BjaS9oZGEvTWFrZWZp
bGUKaW5kZXggNmRiOTJmZC4uMTk4MGM2ZCAxMDA2NDQKLS0tIGEvc291bmQvcGNpL2hkYS9NYWtl
ZmlsZQorKysgYi9zb3VuZC9wY2kvaGRhL01ha2VmaWxlCkBAIC0xNSw1ICsxNSw2IEBAIHNuZC1o
ZGEtaW50ZWwtJChDT05GSUdfU05EX0hEQV9DT0RFQ19TSTMwNTQpICs9IHBhdGNoX3NpMzA1NC5v
CiBzbmQtaGRhLWludGVsLSQoQ09ORklHX1NORF9IREFfQ09ERUNfQVRJSERNSSkgKz0gcGF0Y2hf
YXRpaGRtaS5vCiBzbmQtaGRhLWludGVsLSQoQ09ORklHX1NORF9IREFfQ09ERUNfQ09ORVhBTlQp
ICs9IHBhdGNoX2NvbmV4YW50Lm8KIHNuZC1oZGEtaW50ZWwtJChDT05GSUdfU05EX0hEQV9DT0RF
Q19WSUEpICs9IHBhdGNoX3ZpYS5vCitzbmQtaGRhLWludGVsLSQoQ09ORklHX1NORF9IREFfQ09E
RUNfTlZIRE1JKSArPSBwYXRjaF9udmhkbWkubwogCiBvYmotJChDT05GSUdfU05EX0hEQV9JTlRF
TCkgKz0gc25kLWhkYS1pbnRlbC5vCmRpZmYgLS1naXQgYS9zb3VuZC9wY2kvaGRhL2hkYV9jb2Rl
Yy5jIGIvc291bmQvcGNpL2hkYS9oZGFfY29kZWMuYwppbmRleCA5NGVhNjU0Li5mZGI2ZDU1IDEw
MDY0NAotLS0gYS9zb3VuZC9wY2kvaGRhL2hkYV9jb2RlYy5jCisrKyBiL3NvdW5kL3BjaS9oZGEv
aGRhX2NvZGVjLmMKQEAgLTk0LDYgKzk0LDkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBoZGFfY29k
ZWNfcHJlc2V0ICpoZGFfcHJlc2V0X3RhYmxlc1tdID0gewogI2lmZGVmIENPTkZJR19TTkRfSERB
X0NPREVDX1ZJQQogCXNuZF9oZGFfcHJlc2V0X3ZpYSwKICNlbmRpZgorI2lmZGVmIENPTkZJR19T
TkRfSERBX0NPREVDX05WSERNSQorCXNuZF9oZGFfcHJlc2V0X252aGRtaSwKKyNlbmRpZgogCU5V
TEwKIH07CiAKZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvaGRhX3BhdGNoLmggYi9zb3VuZC9w
Y2kvaGRhL2hkYV9wYXRjaC5oCmluZGV4IDJmZGYyMzUuLmRmYmNmYTggMTAwNjQ0Ci0tLSBhL3Nv
dW5kL3BjaS9oZGEvaGRhX3BhdGNoLmgKKysrIGIvc291bmQvcGNpL2hkYS9oZGFfcGF0Y2guaApA
QCAtMTgsMyArMTgsNSBAQCBleHRlcm4gc3RydWN0IGhkYV9jb2RlY19wcmVzZXQgc25kX2hkYV9w
cmVzZXRfYXRpaGRtaVtdOwogZXh0ZXJuIHN0cnVjdCBoZGFfY29kZWNfcHJlc2V0IHNuZF9oZGFf
cHJlc2V0X2NvbmV4YW50W107CiAvKiBWSUEgY29kZWNzICovCiBleHRlcm4gc3RydWN0IGhkYV9j
b2RlY19wcmVzZXQgc25kX2hkYV9wcmVzZXRfdmlhW107CisvKiBOVklESUEgSERNSSBjb2RlY3Mg
Ki8KK2V4dGVybiBzdHJ1Y3QgaGRhX2NvZGVjX3ByZXNldCBzbmRfaGRhX3ByZXNldF9udmhkbWlb
XTsKZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvcGF0Y2hfbnZoZG1pLmMgYi9zb3VuZC9wY2kv
aGRhL3BhdGNoX252aGRtaS5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjFh
NjU3NzUKLS0tIC9kZXYvbnVsbAorKysgYi9zb3VuZC9wY2kvaGRhL3BhdGNoX252aGRtaS5jCkBA
IC0wLDAgKzEsMTY0IEBACisvKgorICogVW5pdmVyc2FsIEludGVyZmFjZSBmb3IgSW50ZWwgSGln
aCBEZWZpbml0aW9uIEF1ZGlvIENvZGVjCisgKgorICogSEQgYXVkaW8gaW50ZXJmYWNlIHBhdGNo
IGZvciBOVklESUEgSERNSSBjb2RlY3MKKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMDggTlZJRElB
IENvcnAuICBBbGwgcmlnaHRzIHJlc2VydmVkLgorICogQ29weXJpZ2h0IChjKSAyMDA4IFdlaSBO
aSA8d25pQG52aWRpYS5jb20+CisgKgorICoKKyAqICBUaGlzIGRyaXZlciBpcyBmcmVlIHNvZnR3
YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CisgKiAgaXQgdW5kZXIg
dGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQg
YnkKKyAqICB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9m
IHRoZSBMaWNlbnNlLCBvcgorICogIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24u
CisgKgorICogIFRoaXMgZHJpdmVyIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQg
d2lsbCBiZSB1c2VmdWwsCisgKiAgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2
ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqICBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVT
UyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCisgKiAgR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KKyAqCisgKiAgWW91IHNob3VsZCBoYXZlIHJl
Y2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAqICBhbG9u
ZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZQor
ICogIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0b24s
IE1BICAwMjExMS0xMzA3IFVTQQorICovCisKKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5j
bHVkZSA8bGludXgvZGVsYXkuaD4KKyNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CisjaW5jbHVkZSA8
c291bmQvY29yZS5oPgorI2luY2x1ZGUgImhkYV9jb2RlYy5oIgorI2luY2x1ZGUgImhkYV9sb2Nh
bC5oIgorCitzdHJ1Y3QgbnZoZG1pX3NwZWMgeworCXN0cnVjdCBoZGFfbXVsdGlfb3V0IG11bHRp
b3V0OworCisJc3RydWN0IGhkYV9wY20gcGNtX3JlYzsKK307CisKK3N0YXRpYyBzdHJ1Y3QgaGRh
X3ZlcmIgbnZoZG1pX2Jhc2ljX2luaXRbXSA9IHsKKwkvKiBlbmFibGUgZGlnaXRhbCBvdXRwdXQg
b24gcGluIHdpZGdldCAqLworCXsgMHgwNSwgQUNfVkVSQl9TRVRfUElOX1dJREdFVF9DT05UUk9M
LCBQSU5fT1VUIH0sCisJe30gLyogdGVybWluYXRvciAqLworfTsKKworLyoKKyAqIENvbnRyb2xz
CisgKi8KK3N0YXRpYyBpbnQgbnZoZG1pX2J1aWxkX2NvbnRyb2xzKHN0cnVjdCBoZGFfY29kZWMg
KmNvZGVjKQoreworCXN0cnVjdCBudmhkbWlfc3BlYyAqc3BlYyA9IGNvZGVjLT5zcGVjOworCWlu
dCBlcnI7CisKKwllcnIgPSBzbmRfaGRhX2NyZWF0ZV9zcGRpZl9vdXRfY3Rscyhjb2RlYywgc3Bl
Yy0+bXVsdGlvdXQuZGlnX291dF9uaWQpOworCWlmIChlcnIgPCAwKQorCQlyZXR1cm4gZXJyOwor
CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgbnZoZG1pX2luaXQoc3RydWN0IGhkYV9jb2Rl
YyAqY29kZWMpCit7CisJc25kX2hkYV9zZXF1ZW5jZV93cml0ZShjb2RlYywgbnZoZG1pX2Jhc2lj
X2luaXQpOworCXJldHVybiAwOworfQorCisvKgorICogRGlnaXRhbCBvdXQKKyAqLworc3RhdGlj
IGludCBudmhkbWlfZGlnX3BsYXliYWNrX3BjbV9vcGVuKHN0cnVjdCBoZGFfcGNtX3N0cmVhbSAq
aGluZm8sCisJCQkJICAgICBzdHJ1Y3QgaGRhX2NvZGVjICpjb2RlYywKKwkJCQkgICAgIHN0cnVj
dCBzbmRfcGNtX3N1YnN0cmVhbSAqc3Vic3RyZWFtKQoreworCXN0cnVjdCBudmhkbWlfc3BlYyAq
c3BlYyA9IGNvZGVjLT5zcGVjOworCXJldHVybiBzbmRfaGRhX211bHRpX291dF9kaWdfb3Blbihj
b2RlYywgJnNwZWMtPm11bHRpb3V0KTsKK30KKworc3RhdGljIGludCBudmhkbWlfZGlnX3BsYXli
YWNrX3BjbV9jbG9zZShzdHJ1Y3QgaGRhX3BjbV9zdHJlYW0gKmhpbmZvLAorCQkJCSAgICAgIHN0
cnVjdCBoZGFfY29kZWMgKmNvZGVjLAorCQkJCSAgICAgIHN0cnVjdCBzbmRfcGNtX3N1YnN0cmVh
bSAqc3Vic3RyZWFtKQoreworCXN0cnVjdCBudmhkbWlfc3BlYyAqc3BlYyA9IGNvZGVjLT5zcGVj
OworCXJldHVybiBzbmRfaGRhX211bHRpX291dF9kaWdfY2xvc2UoY29kZWMsICZzcGVjLT5tdWx0
aW91dCk7Cit9CisKK3N0YXRpYyBpbnQgbnZoZG1pX2RpZ19wbGF5YmFja19wY21fcHJlcGFyZShz
dHJ1Y3QgaGRhX3BjbV9zdHJlYW0gKmhpbmZvLAorCQkJCQkgICAgc3RydWN0IGhkYV9jb2RlYyAq
Y29kZWMsCisJCQkJCSAgICB1bnNpZ25lZCBpbnQgc3RyZWFtX3RhZywKKwkJCQkJICAgIHVuc2ln
bmVkIGludCBmb3JtYXQsCisJCQkJCSAgICBzdHJ1Y3Qgc25kX3BjbV9zdWJzdHJlYW0gKnN1YnN0
cmVhbSkKK3sKKwlzdHJ1Y3QgbnZoZG1pX3NwZWMgKnNwZWMgPSBjb2RlYy0+c3BlYzsKKwlyZXR1
cm4gc25kX2hkYV9tdWx0aV9vdXRfZGlnX3ByZXBhcmUoY29kZWMsICZzcGVjLT5tdWx0aW91dCwg
c3RyZWFtX3RhZywKKwkJCQkJICAgICBmb3JtYXQsIHN1YnN0cmVhbSk7Cit9CisKK3N0YXRpYyBz
dHJ1Y3QgaGRhX3BjbV9zdHJlYW0gbnZoZG1pX3BjbV9kaWdpdGFsX3BsYXliYWNrID0geworCS5z
dWJzdHJlYW1zID0gMSwKKwkuY2hhbm5lbHNfbWluID0gMiwKKwkuY2hhbm5lbHNfbWF4ID0gMiwK
KwkubmlkID0gMHg0LCAvKiBOSUQgdG8gcXVlcnkgZm9ybWF0cyBhbmQgcmF0ZXMgYW5kIHNldHVw
IHN0cmVhbXMgKi8KKwkucmF0ZXMgPSBTTkRSVl9QQ01fUkFURV80ODAwMCwKKwkubWF4YnBzID0g
MTYsCisJLmZvcm1hdHMgPSBTTkRSVl9QQ01fRk1UQklUX1MxNl9MRSwKKwkub3BzID0geworCQku
b3BlbiA9IG52aGRtaV9kaWdfcGxheWJhY2tfcGNtX29wZW4sCisJCS5jbG9zZSA9IG52aGRtaV9k
aWdfcGxheWJhY2tfcGNtX2Nsb3NlLAorCQkucHJlcGFyZSA9IG52aGRtaV9kaWdfcGxheWJhY2tf
cGNtX3ByZXBhcmUKKwl9LAorfTsKKworc3RhdGljIGludCBudmhkbWlfYnVpbGRfcGNtcyhzdHJ1
Y3QgaGRhX2NvZGVjICpjb2RlYykKK3sKKwlzdHJ1Y3QgbnZoZG1pX3NwZWMgKnNwZWMgPSBjb2Rl
Yy0+c3BlYzsKKwlzdHJ1Y3QgaGRhX3BjbSAqaW5mbyA9ICZzcGVjLT5wY21fcmVjOworCisJY29k
ZWMtPm51bV9wY21zID0gMTsKKwljb2RlYy0+cGNtX2luZm8gPSBpbmZvOworCisJaW5mby0+bmFt
ZSA9ICJOVklESUEgSERNSSI7CisJaW5mby0+c3RyZWFtW1NORFJWX1BDTV9TVFJFQU1fUExBWUJB
Q0tdID0gbnZoZG1pX3BjbV9kaWdpdGFsX3BsYXliYWNrOworCisJcmV0dXJuIDA7Cit9CisKK3N0
YXRpYyB2b2lkIG52aGRtaV9mcmVlKHN0cnVjdCBoZGFfY29kZWMgKmNvZGVjKQoreworCWtmcmVl
KGNvZGVjLT5zcGVjKTsKK30KKworc3RhdGljIHN0cnVjdCBoZGFfY29kZWNfb3BzIG52aGRtaV9w
YXRjaF9vcHMgPSB7CisJLmJ1aWxkX2NvbnRyb2xzID0gbnZoZG1pX2J1aWxkX2NvbnRyb2xzLAor
CS5idWlsZF9wY21zID0gbnZoZG1pX2J1aWxkX3BjbXMsCisJLmluaXQgPSBudmhkbWlfaW5pdCwK
KwkuZnJlZSA9IG52aGRtaV9mcmVlLAorfTsKKworc3RhdGljIGludCBwYXRjaF9udmhkbWkoc3Ry
dWN0IGhkYV9jb2RlYyAqY29kZWMpCit7CisJc3RydWN0IG52aGRtaV9zcGVjICpzcGVjOworCisJ
c3BlYyA9IGt6YWxsb2Moc2l6ZW9mKCpzcGVjKSwgR0ZQX0tFUk5FTCk7CisJaWYgKHNwZWMgPT0g
TlVMTCkKKwkJcmV0dXJuIC1FTk9NRU07CisKKwljb2RlYy0+c3BlYyA9IHNwZWM7CisKKwlzcGVj
LT5tdWx0aW91dC5udW1fZGFjcyA9IDA7CSAgLyogbm8gYW5hbG9nICovCisJc3BlYy0+bXVsdGlv
dXQubWF4X2NoYW5uZWxzID0gMjsKKwlzcGVjLT5tdWx0aW91dC5kaWdfb3V0X25pZCA9IDB4NDsg
LyogTklEIGZvciBjb3B5aW5nIGFuYWxvZyB0byBkaWdpdGFsLAorCQkJCQkgICAqIHNlZW1zIHRv
IGJlIHVudXNlZCBpbiBwdXJlLWRpZ2l0YWwKKwkJCQkJICAgKiBjYXNlLiAqLworCisJY29kZWMt
PnBhdGNoX29wcyA9IG52aGRtaV9wYXRjaF9vcHM7CisKKwlyZXR1cm4gMDsKK30KKworLyoKKyAq
IHBhdGNoIGVudHJpZXMKKyAqLworc3RydWN0IGhkYV9jb2RlY19wcmVzZXQgc25kX2hkYV9wcmVz
ZXRfbnZoZG1pW10gPSB7CisJeyAuaWQgPSAweDEwZGUwMDAyLCAubmFtZSA9ICJOVklESUEgTUNQ
NzggSERNSSIsIC5wYXRjaCA9IHBhdGNoX252aGRtaSB9LAorCXsgLmlkID0gMHgxMGRlMDAwNywg
Lm5hbWUgPSAiTlZJRElBIE1DUDdBIEhETUkiLCAucGF0Y2ggPSBwYXRjaF9udmhkbWkgfSwKKwl7
fSAvKiB0ZXJtaW5hdG9yICovCit9OwotLSAKMS41LjYKCg==

------_=_NextPart_001_01C91F9F.E0A3A584
Content-Type: application/octet-stream;
	name="0002-Fix-for-reading-RIRB-buffer-on-NVIDIA-aza-controller.patch"
Content-Transfer-Encoding: base64
Content-Description: 0002-Fix-for-reading-RIRB-buffer-on-NVIDIA-aza-controller.patch
Content-Disposition: attachment;
	filename="0002-Fix-for-reading-RIRB-buffer-on-NVIDIA-aza-controller.patch"

RnJvbSAyZTc3Nzg3Y2FlNjY1MmE3NmY0OGY0OTljNjEyMThhY2I3MGJhZWU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXZWkgTmkgPHduaUBudmlkaWEuY29tPgpEYXRlOiBGcmksIDI2
IFNlcCAyMDA4IDEzOjU1OjU2ICswODAwClN1YmplY3Q6IFtQQVRDSF0gRml4IGZvciByZWFkaW5n
IFJJUkIgYnVmZmVyIG9uIE5WSURJQSBhemEgY29udHJvbGxlciB3aXRoIEFNRCBQaGVub20gY3B1
CgpTaWduZWQtb2ZmLWJ5OiBXZWkgTmkgPHduaUBudmlkaWEuY29tPgoKV2hlbiByZWFkIFJJUkIg
YnVmZmVyIGltbWVkaWF0ZWx5IGFmdGVyIFJJUkIgaW50ZXJydXB0IHJlY2VpdmVkLCBzb21ldGlt
ZXMgdGhlIGRhdGEgd2lsbCBiZSAiMHgwIi4gSWYgd2Ugd2FpdCBmb3Igc29tZSB0aW1lLCB0aGUg
ZGF0YSBpbiBidWZmZXIgd2lsbCBiZSBjb3JyZWN0LiBUaGlzIGlzc3VlIG9ubHkgb2NjdXJyZWQg
d2l0aCBBTUQgUGhlbm9tIGNwdS4gU28gd2Ugc2V0IHRoaXMgIm5lZWRzX2RhbW5fbG9uZ19kZWxh
eSIgZmxhZy4KLS0tCiBzb3VuZC9wY2kvaGRhL2hkYV9pbnRlbC5jIHwgICAgMyArKysKIDEgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L3NvdW5kL3BjaS9oZGEvaGRhX2ludGVsLmMgYi9zb3VuZC9wY2kvaGRhL2hkYV9pbnRlbC5jCmlu
ZGV4IDYwY2M0NGEuLjlmMzE2YzEgMTAwNjQ0Ci0tLSBhL3NvdW5kL3BjaS9oZGEvaGRhX2ludGVs
LmMKKysrIGIvc291bmQvcGNpL2hkYS9oZGFfaW50ZWwuYwpAQCAtMTIyMCw2ICsxMjIwLDkgQEAg
c3RhdGljIGludCBfX2RldmluaXQgYXp4X2NvZGVjX2NyZWF0ZShzdHJ1Y3QgYXp4ICpjaGlwLCBj
b25zdCBjaGFyICptb2RlbCwKIAlpZiAoZXJyIDwgMCkKIAkJcmV0dXJuIGVycjsKIAorCWlmIChj
aGlwLT5kcml2ZXJfdHlwZSA9PSBBWlhfRFJJVkVSX05WSURJQSkKKwkJY2hpcC0+YnVzLT5uZWVk
c19kYW1uX2xvbmdfZGVsYXkgPSAxOworCiAJY29kZWNzID0gYXVkaW9fY29kZWNzID0gMDsKIAlt
YXhfc2xvdHMgPSBhenhfbWF4X2NvZGVjc1tjaGlwLT5kcml2ZXJfdHlwZV07CiAJaWYgKCFtYXhf
c2xvdHMpCi0tIAoxLjUuNgoK

------_=_NextPart_001_01C91F9F.E0A3A584--
