Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280Ab0ADNvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0ADNvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755Ab0ADNvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:51:13 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59335 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0ADNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AQxBjZjd01AmJSaa37ZXfn2Mr/zcMtlz1n5qJKf09RimnNQvVdnHbT1wSnZGCq1TV3
         3hCYRTuYtiDbSg+KeMV1GYMVdIRKWZvQeNWd+DTIeoUq9Zy9+CA7Sez/ZV9q0y8HIj97
         l1iq3/1Al+DkBIYD5dAODD61B+1JDtYCwizQo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
	 <4964DB3E.6080908@intel.com>
	 <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>
	 <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>
	 <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
Date: Mon, 4 Jan 2010 14:51:08 +0100
Message-ID: <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for 
	temp/voltage monitoring)
From: Gabriel C <nix.or.die@googlemail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Gabriel C <crazy@frugalware.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Andriy Gapon <avg@icyb.net.ua>
Content-Type: multipart/mixed; boundary=0015174762186dd6af047c5703c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174762186dd6af047c5703c1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2009/2/12 Justin Piszcz <jpiszcz@lucidpixels.com>:
>
>
> On Thu, 12 Feb 2009, Gabriel C wrote:
>
>> Maxim Levitsky wrote:
>>
>>> On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
>>>>
>>>> On Wed, 7 Jan 2009, Dan Williams wrote:
>>>>
>>>>> Justin Piszcz wrote:
>>>>>>
>>>>>> The HECI interface would allow lm_sensors developers to grab the
>>>>>> temperatures off the chips on the board.
>>>>>>
>>>>>> From 2005(?)-2008 there was some chatter about supporting it but it
>>>>>> never
>>>>>> seemed to happen, is there any eventual planned support for supporti=
ng
>>>>>> Intel's HECI interface or if the user wants to see the
>>>>>> temperatures/voltages just buy a different motherboard with an ITE I=
/O
>>>>>> controller?
>>>>>>
>>>>>> I have a couple DG965WH boards and it would be nice to see the
>>>>>> temperature of the chipset etc without having to reboot into the BIO=
S.
>>>>>>
>>>>> Hi Justin,
>>>>>
>>>>> I am not up to date on the progress in this area, but perhaps this si=
te
>>>>> (http://www.openamt.org/) has what you are looking for?
>>>>>
>>>>> Regards,
>>>>> Dan
>>>>>
>>>> Yeah that is the site-- however, will it ever get merged? =A0I have no=
t
>>>> heard anything about it for a year or so.
>>>
>>> Nope, the heci is just a controller, but we need a way to tell that
>>> controller to show us the temperature data.
>>> But intel hasn't released the QST sdk, and probably never will.
>>>
>>> Sad,
>>
>>
>> Well I found this interesting thread about :
>>
>>
>> http://software.intel.com/en-us/forums/manageability-software-developmen=
t/topic/54851/
>>
>> It looks like the QST SDK already exists and is planned to be released..
>> (
>> =A0http://software.intel.com/en-us/forums/manageability-software-develop=
ment/topic/54851/reply/74068/
>> )
> I volunteer to test any patches if/when they are created after the SDK is
> released.
>


Again me .. Well the SDK is *still* not released .. =A0The Intel folks
said back in August :

"The latest word is that the SDK is being prepared for approval but it
is contingent upon an upcoming platform release."

( whatever that means )


Anyway Andriy Gapon has posted on lm-sensors some nice tool to read
the sensors output ( thx :) )
(http://lists.lm-sensors.org/pipermail/lm-sensors/2009-October/026830.html)

Today I'm out from hospital so I've decided to quick hack this tool
and make it work on Linux.

Here the output from my DQ45CB mobo:

crazy@thor:~/INTEL/QST/Li$ sudo ./heci-qst
CPU =A0Temp: =A0 =A0 =A056.00 =A0 =B0C
MB =A0 Temp: =A0 =A0 =A031.14 =A0 =B0C
ICH =A0Temp: =A0 =A0 =A067.37 =A0 =B0C
MCH =A0Temp: =A0 =A0 =A066.00 =A0 =B0C
CPU =A0Fan: =A0 =A0 =A0 1080 =A0 =A0RPM
INL =A0Fan: =A0 =A0 =A0 1202 =A0 =A0RPM
OUTL Fan: =A0 =A0 =A0 288 =A0 =A0 RPM
+12 =A0Volts: =A0 =A0 11.965 =A0V
+5 =A0 Volts: =A0 =A0 5.021 =A0 V
+3.3 Volts: =A0 =A0 3.316 =A0 V
MCH =A0Vccp: =A0 =A0 =A01.122 =A0 V
CPU1 Vccp: =A0 =A0 =A01.125 =A0 V

Justin I know is not based on released SDK of Intel but maybe you
still want to do some tests ?:)

( of course you need the heci kernel modules first )

@Andriy there is a smallish bug in your original code .. you should
use ..... , abs(value) ...., abs(value) ...);
that will solve the negative CPU TEMP values you get with your version.

Best Regards,

Gabriel C

--0015174762186dd6af047c5703c1
Content-Type: application/octet-stream; name="heci-qst-linux.c"
Content-Disposition: attachment; filename="heci-qst-linux.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g41d585q0

LyotCiAqIENvcHlyaWdodCAoYykgMjAwOSBBbmRyaXkgR2Fwb24gPGF2Z0BpY3liLm5ldC51YT4K
ICogQ29weXJpZ2h0IChjKSAyMDA5IEdhYnJpZWwgQ3JhY2l1bmVzY3UgPGNyYXp5QGZydWdhbHdh
cmUub3JnPgogKiAoIEFkZGVkIHNvbWUgTGludXggc3VwcG9ydCApCiAqIEFsbCByaWdodHMgcmVz
ZXJ2ZWQuCiAqCiAqIFJlZGlzdHJpYnV0aW9uIGFuZCB1c2UgaW4gc291cmNlIGFuZCBiaW5hcnkg
Zm9ybXMsIHdpdGggb3Igd2l0aG91dAogKiBtb2RpZmljYXRpb24sIGFyZSBwZXJtaXR0ZWQgcHJv
dmlkZWQgdGhhdCB0aGUgZm9sbG93aW5nIGNvbmRpdGlvbnMKICogYXJlIG1ldDoKICogMS4gUmVk
aXN0cmlidXRpb25zIG9mIHNvdXJjZSBjb2RlIG11c3QgcmV0YWluIHRoZSBhYm92ZSBjb3B5cmln
aHQKICogICAgbm90aWNlLCB0aGlzIGxpc3Qgb2YgY29uZGl0aW9ucyBhbmQgdGhlIGZvbGxvd2lu
ZyBkaXNjbGFpbWVyLgogKiAyLiBSZWRpc3RyaWJ1dGlvbnMgaW4gYmluYXJ5IGZvcm0gbXVzdCBy
ZXByb2R1Y2UgdGhlIGFib3ZlIGNvcHlyaWdodAogKiAgICBub3RpY2UsIHRoaXMgbGlzdCBvZiBj
b25kaXRpb25zIGFuZCB0aGUgZm9sbG93aW5nIGRpc2NsYWltZXIgaW4gdGhlCiAqICAgIGRvY3Vt
ZW50YXRpb24gYW5kL29yIG90aGVyIG1hdGVyaWFscyBwcm92aWRlZCB3aXRoIHRoZSBkaXN0cmli
dXRpb24uCiAqCiAqIFRISVMgU09GVFdBUkUgSVMgUFJPVklERUQgQlkgVEhFIEFVVEhPUiBBTkQg
Q09OVFJJQlVUT1JTIEFTIElTJycgQU5ECiAqIEFOWSBFWFBSRVNTIE9SIElNUExJRUQgV0FSUkFO
VElFUywgSU5DTFVESU5HLCBCVVQgTk9UIExJTUlURUQgVE8sIFRIRQogKiBJTVBMSUVEIFdBUlJB
TlRJRVMgT0YgTUVSQ0hBTlRBQklMSVRZIEFORCBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVS
UE9TRQogKiBBUkUgRElTQ0xBSU1FRC4gIElOIE5PIEVWRU5UIFNIQUxMIFRIRSBBVVRIT1IgT1Ig
Q09OVFJJQlVUT1JTIEJFIExJQUJMRQogKiBGT1IgQU5ZIERJUkVDVCwgSU5ESVJFQ1QsIElOQ0lE
RU5UQUwsIFNQRUNJQUwsIEVYRU1QTEFSWSwgT1IgQ09OU0VRVUVOVElBTAogKiBEQU1BR0VTIChJ
TkNMVURJTkcsIEJVVCBOT1QgTElNSVRFRCBUTywgUFJPQ1VSRU1FTlQgT0YgU1VCU1RJVFVURSBH
T09EUwogKiBPUiBTRVJWSUNFUzsgTE9TUyBPRiBVU0UsIERBVEEsIE9SIFBST0ZJVFM7IE9SIEJV
U0lORVNTIElOVEVSUlVQVElPTikKICogSE9XRVZFUiBDQVVTRUQgQU5EIE9OIEFOWSBUSEVPUlkg
T0YgTElBQklMSVRZLCBXSEVUSEVSIElOIENPTlRSQUNULCBTVFJJQ1QKICogTElBQklMSVRZLCBP
UiBUT1JUIChJTkNMVURJTkcgTkVHTElHRU5DRSBPUiBPVEhFUldJU0UpIEFSSVNJTkcgSU4gQU5Z
IFdBWQogKiBPVVQgT0YgVEhFIFVTRSBPRiBUSElTIFNPRlRXQVJFLCBFVkVOIElGIEFEVklTRUQg
T0YgVEhFIFBPU1NJQklMSVRZIE9GCiAqIFNVQ0ggREFNQUdFLgogKi8KCiNpbmNsdWRlIDxzdGRp
by5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPGZj
bnRsLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPGxpbnV4L2lvY3RsLmg+CiNpbmNs
dWRlIDxpbnR0eXBlcy5oPgoKLyogaGVjaS5oIGluIGxpbnV4IGlzIGJyb2tlbiAuLi4gd2hhdCBh
IHN1cnByaXNlIDpQICovCgpzdHJ1Y3QgZ3VpZAp7CiAgICAgICAgdWludDMyX3QgICBkYXRhMTsK
ICAgICAgICB1aW50MTZfdCAgIGRhdGEyOwogICAgICAgIHVpbnQxNl90ICAgZGF0YTM7CiAgICAg
ICAgdWludDhfdCAgIGRhdGE0WzhdOwoKfTsKCnN0cnVjdCBoZWNpX21lc3NhZ2VfZGF0YQp7CiAg
ICAgICAgdWludDMyX3Qgc2l6ZTsKICAgICAgICBjaGFyICpkYXRhOwp9X19hdHRyaWJ1dGVfXygo
cGFja2VkKSk7CgoKI3VuZGVmIElPQ1RMX0hFQ0lfQ09OTkVDVF9DTElFTlQKI2RlZmluZSBJT0NU
TF9IRUNJX0NPTk5FQ1RfQ0xJRU5UIF9JT1dSKDB4NDgsIDB4MDEsIHN0cnVjdCBoZWNpX21lc3Nh
Z2VfZGF0YSkKCnN0cnVjdCB0aGVybV9zZW5zb3IKewoJaW50OF90IHZhbGlkOwoJaW50MzJfdCB2
YWx1ZTsKfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKCnN0cnVjdCB2b2x0X3NlbnNvcgp7Cglp
bnQ4X3QgdmFsaWQ7CglpbnQzMl90IHZhbHVlOwp9IF9fYXR0cmlidXRlX18oKHBhY2tlZCkpOwoK
c3RydWN0IGZhbl9zZW5zb3IKewoJaW50OF90IHZhbGlkOwoJaW50MTZfdCB2YWx1ZTsKfSBfX2F0
dHJpYnV0ZV9fKChwYWNrZWQpKTsKCiNkZWZpbmUgVEhFUk1fU0VOU09SX0NPVU5UCTEyCnN0cnVj
dCB0aGVybV9kYXRhCnsKCWludDhfdCBzdGF0dXM7CglzdHJ1Y3QgdGhlcm1fc2Vuc29yIGRhdGFb
VEhFUk1fU0VOU09SX0NPVU5UXTsKfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKCiNkZWZpbmUg
Vk9MVF9TRU5TT1JfQ09VTlQJOApzdHJ1Y3Qgdm9sdF9kYXRhCnsKCWludDhfdCBzdGF0dXM7Cglz
dHJ1Y3Qgdm9sdF9zZW5zb3IgZGF0YVtWT0xUX1NFTlNPUl9DT1VOVF07Cn0gX19hdHRyaWJ1dGVf
XygocGFja2VkKSk7CgojZGVmaW5lIEZBTl9TRU5TT1JfQ09VTlQJOApzdHJ1Y3QgZmFuX2RhdGEK
ewoJaW50OF90IHN0YXR1czsKCXN0cnVjdCBmYW5fc2Vuc29yIGRhdGFbRkFOX1NFTlNPUl9DT1VO
VF07Cn0gX19hdHRyaWJ1dGVfXygocGFja2VkKSk7CgpzdHJ1Y3QgcXN0X2NtZAp7Cgl1aW50OF90
IGNtZDsKCXVpbnQxNl90IGluX2xlbjsKCXVpbnQxNl90IG91dF9sZW47Cn0gX19hdHRyaWJ1dGVf
XygocGFja2VkKSk7CgoKI2RlZmluZSBRU1RfVEhFUk1BTF9DTUQJCTB4MTIKc3RhdGljIGNvbnN0
IHN0cnVjdCBxc3RfY21kIHRoZXJtX2NtZCA9IHsgUVNUX1RIRVJNQUxfQ01ELCAwLCBzaXplb2Yo
c3RydWN0IHRoZXJtX2RhdGEpIH07CgojZGVmaW5lIFFTVF9WT0xUX0NNRAkJMHg1OApzdGF0aWMg
Y29uc3Qgc3RydWN0IHFzdF9jbWQgdm9sdF9jbWQgPSB7IFFTVF9WT0xUX0NNRCwgMCwgc2l6ZW9m
KHN0cnVjdCB2b2x0X2RhdGEpIH07CgojZGVmaW5lIFFTVF9GQU5fQ01ECQkweDM3CnN0YXRpYyBj
b25zdCBzdHJ1Y3QgcXN0X2NtZCBmYW5fY21kID0geyBRU1RfRkFOX0NNRCwgMCwgc2l6ZW9mKHN0
cnVjdCBmYW5fZGF0YSkgfTsKCi8qIEhtbW1tIHNlZW1zIHRoZSBvdXRwdXQgaXMgZGlmZmVyZW50
IGRlcGVpbmRpbmcgb24gY2hpcHNldCAvIElDSCB2ZXJzaW9uICovCi8qIE9uIG15IERRNDVDQiAo
IElDSDEwRE8gLyBRNDUgKSBtb2JvIHRoaXMgaXMgcmlnaHQKICBhbHNvIGlzIHRoZSBzYW1lIG91
dHB1dCBJbnRlbCBEZXNrdG9wIFV0aWxzIGlzIGdpdmluZyBtZSAqLwoKY29uc3QgY2hhciAqIGNv
bnN0IHRlbXBfbmFtZXNbVEhFUk1fU0VOU09SX0NPVU5UXSA9IHsKCSJDUFUgIFRlbXAiLAoJIk1C
ICAgVGVtcCIsCgkiSUNIICBUZW1wIiwKCSJNQ0ggIFRlbXAiLAoJTlVMTCwKCU5VTEwsCglOVUxM
LAoJTlVMTCwKCU5VTEwsCglOVUxMLAoJTlVMTCwKCU5VTEwsCn07Cgpjb25zdCBjaGFyICogY29u
c3Qgdm9sdF9uYW1lc1tWT0xUX1NFTlNPUl9DT1VOVF0gPSB7CgkiKzEyICBWb2x0cyIsCgkiKzUg
ICBWb2x0cyIsCgkiKzMuMyBWb2x0cyIsCgkiTUNIICBWY2NwIiwKCSJDUFUxIFZjY3AiLAoJTlVM
TCwKCU5VTEwsCglOVUxMLAp9OwoKY29uc3QgY2hhciAqIGNvbnN0IGZhbl9uYW1lc1tGQU5fU0VO
U09SX0NPVU5UXSA9IHsKCSJDUFUgIEZhbiIsCgkiSU5MICBGYW4iLAoJIk9VVEwgRmFuIiwKCSJB
VVggIEZhbiIsCglOVUxMLAoJTlVMTCwKCU5VTEwsCglOVUxMLAp9OwoKCnN0YXRpYyBjb25zdCBz
dHJ1Y3QgZ3VpZCBfaHdtX2d1aWQgPSB7CgkweDZCNTIwNUI5LAoJMHg4MTg1LAoJMHg0NTE5LAoJ
ezB4QjgsIDB4ODksIDB4RDksIDB4ODcsIDB4MjQsIDB4QjUsIDB4ODYsIDB4MDd9Cn07CgoKaW50
IG1haW4oKQp7CglpbnQgZmQ7CglpbnQgcmM7CglpbnQgaTsKCXN0cnVjdCBoZWNpX21lc3NhZ2Vf
ZGF0YSBod21fZ3VpZDsKCglmZCA9IG9wZW4oIi9kZXYvaGVjaSIsIE9fUkRXUik7CglpZiAoZmQg
PCAwKSB7CgkJcGVycm9yKCIvZGV2L2hlY2kiKTsKCQlmcHJpbnRmKHN0ZGVyciwgIlBsZWFzZSBs
b2FkIHRoZSBIRUNJIEtlcm5lbCBtb2R1bGUgZmlyc3QhXG4iKTsKCQlyZXR1cm4gMTsKCX0KCglo
d21fZ3VpZC5zaXplID0gc2l6ZW9mKHN0cnVjdCBndWlkKTsKCWh3bV9ndWlkLmRhdGEgPSAoY2hh
ciAqKW1hbGxvYyhod21fZ3VpZC5zaXplKTsKCglpZighaHdtX2d1aWQuZGF0YSkgewoJCWZwcmlu
dGYoc3RkZXJyLCAibWFsbG9jIGZhaWx1cmUuXG4iKTsKCQlyZXR1cm4gMTsKCX0KCgltZW1jcHko
aHdtX2d1aWQuZGF0YSwgJl9od21fZ3VpZCwgc2l6ZW9mKF9od21fZ3VpZCkpOwoJcmMgPSBpb2N0
bChmZCwgSU9DVExfSEVDSV9DT05ORUNUX0NMSUVOVCwgJmh3bV9ndWlkKTsKCglpZiAocmMgPCAw
KSB7CgkJcGVycm9yKCJpb2N0bCBJT0NUTF9IRUNJX0NPTk5FQ1RfQ0xJRU5UIik7CgkJcmV0dXJu
IDE7Cgl9CgkvKiBSZXF1ZXN0IHRlbXAuICovCglzdHJ1Y3QgdGhlcm1fZGF0YSB0aGVybV9kYXRh
OwoJcmMgPSB3cml0ZShmZCwgJnRoZXJtX2NtZCwgc2l6ZW9mKHRoZXJtX2NtZCkpOwoJaWYgKHJj
IDwgMCkgewoJCXBlcnJvcigidGhlcm0gd3JpdGUiKTsKCQlyZXR1cm4gMTsKCX0KCglyYyA9IHJl
YWQoZmQsICZ0aGVybV9kYXRhLCBzaXplb2YodGhlcm1fZGF0YSkpOwoJaWYgKHJjIDwgMCkgewoJ
CXBlcnJvcigidGhlcm0gcmVhZCIpOwoJCXJldHVybiAxOwoJfQoKCWZvciAoaSA9IDA7IGkgPCBU
SEVSTV9TRU5TT1JfQ09VTlQ7IGkrKykgewoJCWlmICh0aGVybV9kYXRhLmRhdGFbaV0udmFsaWQp
IHsKCQkJaW50MzJfdCB2YWx1ZSA9IHRoZXJtX2RhdGEuZGF0YVtpXS52YWx1ZTsKCQkJaWYgKHRl
bXBfbmFtZXNbaV0pCgkJCQlwcmludGYoIiVzIiwgdGVtcF9uYW1lc1tpXSk7CgkJCWVsc2UKCQkJ
CXByaW50ZigiJTAyZCIsIGkpOwoJCQlwcmludGYoIjpcdCVkLiUwMmQgXHSwQ1xuIiwgYWJzKHZh
bHVlKSAvIDEwMCwgYWJzKHZhbHVlKSAlIDEwMCk7CgkJfQoJfQoKCS8qIFJlcXVlc3QgZmFucyAq
LwoJc3RydWN0IGZhbl9kYXRhIGZhbl9kYXRhOwoJcmMgPSB3cml0ZShmZCwgJmZhbl9jbWQsIHNp
emVvZihmYW5fY21kKSk7CglpZiAocmMgPCAwKSB7CgkJcGVycm9yKCJmYW4gd3JpdGUiKTsKCQly
ZXR1cm4gMTsKCX0KCglyYyA9IHJlYWQoZmQsICZmYW5fZGF0YSwgc2l6ZW9mKGZhbl9kYXRhKSk7
CglpZiAocmMgPCAwKSB7CgkJcGVycm9yKCJmYW4gcmVhZCIpOwoJCXJldHVybiAxOwoJfQoJZm9y
IChpID0gMDsgaSA8IEZBTl9TRU5TT1JfQ09VTlQ7IGkrKykgewoJCWlmIChmYW5fZGF0YS5kYXRh
W2ldLnZhbGlkKSB7CgkJCWludDMyX3QgdmFsdWUgPSBmYW5fZGF0YS5kYXRhW2ldLnZhbHVlOwoK
CQkJaWYgKGZhbl9uYW1lc1tpXSkKCQkJCXByaW50ZigiJXMiLCBmYW5fbmFtZXNbaV0pOwoJCQll
bHNlCgkJCQlwcmludGYoIiUwMmQiLCBpKTsKCQkJcHJpbnRmKCI6XHQlZCBcdFJQTVxuIiwgdmFs
dWUpOwoJCX0KCX0KCgkvKiBSZXF1ZXN0IHZvbHRzLiAqLwoJc3RydWN0IHZvbHRfZGF0YSB2b2x0
X2RhdGE7CglyYyA9IHdyaXRlKGZkLCAmdm9sdF9jbWQsIHNpemVvZih2b2x0X2NtZCkpOwoJaWYg
KHJjIDwgMCkgewoJCXBlcnJvcigidm9sdHMgd3JpdGUiKTsKCQlyZXR1cm4gMTsKCX0KCglyYyA9
IHJlYWQoZmQsICZ2b2x0X2RhdGEsIHNpemVvZih2b2x0X2RhdGEpKTsKCWlmIChyYyA8IDApIHsK
CQlwZXJyb3IoInZvbHRzIHJlYWQiKTsKCQlyZXR1cm4gMTsKCX0KCWZvciAoaSA9IDA7IGkgPCBW
T0xUX1NFTlNPUl9DT1VOVDsgaSsrKSB7CgkJaWYgKHZvbHRfZGF0YS5kYXRhW2ldLnZhbGlkKSB7
CgkJCWludDMyX3QgdmFsdWUgPSB2b2x0X2RhdGEuZGF0YVtpXS52YWx1ZTsKCgkJCWlmICh2b2x0
X25hbWVzW2ldKQoJCQkJcHJpbnRmKCIlcyIsIHZvbHRfbmFtZXNbaV0pOwoJCQllbHNlCgkJCQlw
cmludGYoIiUwMmQiLCBpKTsKCQkJcHJpbnRmKCI6XHQlZC4lMDNkIFx0VlxuIiwgYWJzKHZhbHVl
KSAvIDEwMDAsIGFicyh2YWx1ZSkgJSAxMDAwKTsKCQl9Cgl9CgljbG9zZShmZCk7CglyZXR1cm4g
MDsKfQoK
--0015174762186dd6af047c5703c1--
