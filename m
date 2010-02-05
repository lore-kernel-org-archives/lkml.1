Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab0BEJTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:19:05 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:65010 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab0BEJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:19:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jwoycuTmF9W7dlQGIDMMT5J2eu/wxWTAsjHT2x/whu6DPMVyXbMVr0dyp6PwyjZsUz
         lWszy+KcJBxuD8qmfKToyV9nnSVvN5z/ur/SZljWfhr4OQA5dDentVz9GS7A7wRUzeZN
         ucHE+gi3VwSBdLvbs8YOlZioaBHb+nz0emeCg=
MIME-Version: 1.0
In-Reply-To: <20100205090009.GA8272@elte.hu>
References: <20100204190649.GB6665@elte.hu> <20100204193232.GD6665@elte.hu>
	 <20100204115316.69beee75@jbarnes-piketon>
	 <20100204202254.GA24716@elte.hu>
	 <20100204204829.GA24608@srcf.ucam.org>
	 <20100204210559.GC19050@elte.hu>
	 <20100204210950.GA25295@srcf.ucam.org> <20100205075645.GF9320@elte.hu>
	 <alpine.DEB.2.00.1002050832450.2995@skynet.skynet.ie>
	 <20100205090009.GA8272@elte.hu>
Date: Fri, 5 Feb 2010 19:18:58 +1000
Message-ID: <21d7e9971002050118h7ff48386v2c8fede0519b8975@mail.gmail.com>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch 
	out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Content-Type: multipart/mixed; boundary=005045016abd001f11047ed6f1f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--005045016abd001f11047ed6f1f5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 5, 2010 at 7:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Airlie <airlied@linux.ie> wrote:
>
>>
>> > If it now does not boot up if all its sub-options are enabled, even of=
 some
>> > of those sub-options are new, does that count as a driver regression? =
Sure it
>> > does to me ...
>>
>> But it doesn't to anyone else under any reasonable meaning of the word
>> regression.
>
> There are reactions in this thread that contradict your 'anyone else' poi=
nt.
>
>> The config option states
>> "Choose this option if you want kernel modesetting enabled by default,
>> =A0 =A0 =A0 =A0 =A0 and you have a new enough userspace to support this.=
 Running old
>> =A0 =A0 =A0 =A0 =A0 userspaces with this enabled will cause pain."
>>
>> Will cause pain sounds painful to me, I can make it seem much worse if
>> you'd like.
>
> Except you are missing that the hang (and the first crash as well) happen=
s on
> brand-new user-space just as much - not just on 'old userspaces'.
>
> The bugs i've triggered are independent of any user-space component - it
> happens with a fresh distro just as much.
>
> As i suggested before, at least the text should be updated to include wha=
t
> has been written about CONFIG_DRM_RADEON_KMS in this thread before:
>
> =A0> This is a completely new driver. =A0It's only part of the existing d=
rm for
> =A0> compatibility reasons. =A0It requires an entirely different graphics=
 stack
> =A0> above it and works very differently from the old drm stack.
>

Okay I've attached a patch with a revised Kconfig in it.

Does this sound more like reality?

Dave.

--005045016abd001f11047ed6f1f5
Content-Type: application/octet-stream; 
	name="0001-drm-radeon-kms-change-Kconfig-text-to-reflect-the-ne.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-change-Kconfig-text-to-reflect-the-ne.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5arh1nz0

RnJvbSAwYTBjMjgxMDNlOWFiZjc3YWM2Y2Y1Nzk4MjFlNTE1NTdmMDE5NGFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBGcmksIDUgRmViIDIwMTAgMTk6MDI6MjQgKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm0vcmFk
ZW9uL2ttczogY2hhbmdlIEtjb25maWcgdGV4dCB0byByZWZsZWN0IHRoZSBuZXcgb3B0aW9uLgoK
SW5nbyBwb2ludGVkIG91dCB0aGF0IHdlIHJlYWxseSBkb24ndCBnaXZlIHRoZSB1c2VyIGVub3Vn
aCB3YXJuaW5nIHRvIG1ha2UKYSBkZWNpc2lvbiBoZXJlLiBTbyByZXZpc2UgdGhlIEtjb25maWcg
dGV4dCB3aXRoIGEgYmV0dGVyIHdhcm5pbmcuCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIEFpcmxpZSA8
YWlybGllZEByZWRoYXQuY29tPgotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vS2NvbmZpZyB8
ICAgMTIgKysrKysrKystLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL0tjb25maWcg
Yi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL0tjb25maWcKaW5kZXggNTk4MjMyMS4uMWMwMmQyMyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9LY29uZmlnCisrKyBiL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vS2NvbmZpZwpAQCAtMSwxMCArMSwxNCBAQAogY29uZmlnIERSTV9SQURF
T05fS01TCi0JYm9vbCAiRW5hYmxlIG1vZGVzZXR0aW5nIG9uIHJhZGVvbiBieSBkZWZhdWx0Igor
CWJvb2wgIkVuYWJsZSBtb2Rlc2V0dGluZyBvbiByYWRlb24gYnkgZGVmYXVsdCAtIE5FVyBEUklW
RVIiCiAJZGVwZW5kcyBvbiBEUk1fUkFERU9OCiAJaGVscAotCSAgQ2hvb3NlIHRoaXMgb3B0aW9u
IGlmIHlvdSB3YW50IGtlcm5lbCBtb2Rlc2V0dGluZyBlbmFibGVkIGJ5IGRlZmF1bHQsCi0JICBh
bmQgeW91IGhhdmUgYSBuZXcgZW5vdWdoIHVzZXJzcGFjZSB0byBzdXBwb3J0IHRoaXMuIFJ1bm5p
bmcgb2xkCi0JICB1c2Vyc3BhY2VzIHdpdGggdGhpcyBlbmFibGVkIHdpbGwgY2F1c2UgcGFpbi4K
KwkgIENob29zZSB0aGlzIG9wdGlvbiBpZiB5b3Ugd2FudCBrZXJuZWwgbW9kZXNldHRpbmcgZW5h
YmxlZCBieSBkZWZhdWx0LgorCisJICBUaGlzIGlzIGEgY29tcGxldGVseSBuZXcgZHJpdmVyLiBJ
dCdzIG9ubHkgcGFydCBvZiB0aGUgZXhpc3RpbmcgZHJtCisJICBmb3IgY29tcGF0aWJpbGl0eSBy
ZWFzb25zLiBJdCByZXF1aXJlcyBhbiBlbnRpcmVseSBkaWZmZXJlbnQgZ3JhcGhpY3MKKwkgIHN0
YWNrIGFib3ZlIGl0IGFuZCB3b3JrcyB2ZXJ5IGRpZmZlcmVudGx5IGZyb20gdGhlIG9sZCBkcm0g
c3RhY2suCisJICBpLmUuIGRvbid0IGVuYWJsZSB0aGlzIHVubGVzcyB5b3Uga25vdyB3aGF0IHlv
dSBhcmUgZG9pbmcgaXQgbWF5CisJICBjYXVzZSBpc3N1ZXMgb3IgYnVncyBjb21wYXJlZCB0byB0
aGUgcHJldmlvdXMgdXNlcnNwYWNlIGRyaXZlciBzdGFjay4KIAogCSAgV2hlbiBrZXJuZWwgbW9k
ZXNldHRpbmcgaXMgZW5hYmxlZCB0aGUgSU9DVEwgb2YgcmFkZW9uL2RybQogCSAgZHJpdmVyIGFy
ZSBjb25zaWRlcmVkIGFzIGludmFsaWQgYW5kIGFuIGVycm9yIG1lc3NhZ2UgaXMgcHJpbnRlZAot
LSAKMS42LjYKCg==
--005045016abd001f11047ed6f1f5--
