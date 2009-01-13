Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbZAMNIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbZAMNIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZAMNIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:08:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:43355 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZAMNID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IGC2eR9ErezEZKD/WV8UVPKEZruiCLo6f3Bi8kGwg0Jplk+QWZL1w/PE7v0DxwTZoX
         2vGnCBiLtLc3KEOuXEt242Sy+zdj/TRvxzEGbUW/74Zitw75Afgrnfte7rX764jxjAA9
         hXhGMlMQdN7Mn/71jFf+6KzEGVBQ4muUtsZ5Q=
MIME-Version: 1.0
In-Reply-To: <20090113125705.GC7682@localhost>
References: <20090113120905.GB7682@localhost> <20090113125705.GC7682@localhost>
Date: Tue, 13 Jan 2009 18:38:02 +0530
Message-ID: <3f9a31f40901130508w7e7c1be8gac25e019e6430858@mail.gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of 
	asm/types.h
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Content-Type: multipart/mixed; boundary=0016e64dd4ced083a704605ce9dc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64dd4ced083a704605ce9dc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Jan 13, 2009 at 6:27 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Cyrill Gorcunov - Tue, Jan 13, 2009 at 03:09:05PM +0300]
> | Impact: cleanup
> |
> | 'make headers_check' warns that linux/types.h is
> | preferred over asm/types.h. So be it.
> |
> | Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> | CC: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> | CC: Sam Ravnborg <sam@ravnborg.org>
> | CC: Harvey Harrison <harvey.harrison@gmail.com>
> | ---
> |
> |  arch/x86/include/asm/e820.h       |    2 ++
> |  arch/x86/include/asm/kvm.h        |    2 +-
> |  arch/x86/include/asm/mce.h        |    2 +-
> |  arch/x86/include/asm/mtrr.h       |    1 +
> |  arch/x86/include/asm/ptrace-abi.h |    2 +-
> |  arch/x86/include/asm/sigcontext.h |    2 +-
> |  arch/x86/include/asm/swab.h       |    2 +-
> |  7 files changed, 8 insertions(+), 5 deletions(-)
> |
> ...
>
> well... on the other hand I'm not sure if it's really
> a good idea to include linux/types.h where we need only
> __u[8,16] and so on definitions.
>
> Ingo, don't apply this patch please -- have to check
> for other ways.
>

I am attaching usr/include/linux/types.h for your reference which
includes all these definations for userspace.

Thanks
--
JSR

--0016e64dd4ced083a704605ce9dc
Content-Type: text/plain; charset=US-ASCII; name="types.h"
Content-Disposition: attachment; filename="types.h"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpwkukul0

I2lmbmRlZiBfTElOVVhfVFlQRVNfSAojZGVmaW5lIF9MSU5VWF9UWVBFU19ICgoKI2luY2x1ZGUg
PGxpbnV4L3Bvc2l4X3R5cGVzLmg+CiNpbmNsdWRlIDxhc20vdHlwZXMuaD4KCiNpZm5kZWYgX19L
RVJORUxfU1RSSUNUX05BTUVTCgp0eXBlZGVmIF9fdTMyIF9fa2VybmVsX2Rldl90OwoKdHlwZWRl
ZiBfX2tlcm5lbF9mZF9zZXQJCWZkX3NldDsKdHlwZWRlZiBfX2tlcm5lbF9kZXZfdAkJZGV2X3Q7
CnR5cGVkZWYgX19rZXJuZWxfaW5vX3QJCWlub190Owp0eXBlZGVmIF9fa2VybmVsX21vZGVfdAkJ
bW9kZV90Owp0eXBlZGVmIF9fa2VybmVsX25saW5rX3QJbmxpbmtfdDsKdHlwZWRlZiBfX2tlcm5l
bF9vZmZfdAkJb2ZmX3Q7CnR5cGVkZWYgX19rZXJuZWxfcGlkX3QJCXBpZF90Owp0eXBlZGVmIF9f
a2VybmVsX2RhZGRyX3QJZGFkZHJfdDsKdHlwZWRlZiBfX2tlcm5lbF9rZXlfdAkJa2V5X3Q7CnR5
cGVkZWYgX19rZXJuZWxfc3VzZWNvbmRzX3QJc3VzZWNvbmRzX3Q7CnR5cGVkZWYgX19rZXJuZWxf
dGltZXJfdAl0aW1lcl90Owp0eXBlZGVmIF9fa2VybmVsX2Nsb2NraWRfdAljbG9ja2lkX3Q7CnR5
cGVkZWYgX19rZXJuZWxfbXFkX3QJCW1xZF90OwoKdHlwZWRlZiBfX2tlcm5lbF91aWRfdAkJdWlk
X3Q7CnR5cGVkZWYgX19rZXJuZWxfZ2lkX3QJCWdpZF90OwoKI2lmIGRlZmluZWQoX19HTlVDX18p
CnR5cGVkZWYgX19rZXJuZWxfbG9mZl90CQlsb2ZmX3Q7CiNlbmRpZgoKLyoKICogVGhlIGZvbGxv
d2luZyB0eXBlZGVmcyBhcmUgYWxzbyBwcm90ZWN0ZWQgYnkgaW5kaXZpZHVhbCBpZmRlZnMgZm9y
CiAqIGhpc3RvcmljYWwgcmVhc29uczoKICovCiNpZm5kZWYgX1NJWkVfVAojZGVmaW5lIF9TSVpF
X1QKdHlwZWRlZiBfX2tlcm5lbF9zaXplX3QJCXNpemVfdDsKI2VuZGlmCgojaWZuZGVmIF9TU0la
RV9UCiNkZWZpbmUgX1NTSVpFX1QKdHlwZWRlZiBfX2tlcm5lbF9zc2l6ZV90CXNzaXplX3Q7CiNl
bmRpZgoKI2lmbmRlZiBfUFRSRElGRl9UCiNkZWZpbmUgX1BUUkRJRkZfVAp0eXBlZGVmIF9fa2Vy
bmVsX3B0cmRpZmZfdAlwdHJkaWZmX3Q7CiNlbmRpZgoKI2lmbmRlZiBfVElNRV9UCiNkZWZpbmUg
X1RJTUVfVAp0eXBlZGVmIF9fa2VybmVsX3RpbWVfdAkJdGltZV90OwojZW5kaWYKCiNpZm5kZWYg
X0NMT0NLX1QKI2RlZmluZSBfQ0xPQ0tfVAp0eXBlZGVmIF9fa2VybmVsX2Nsb2NrX3QJY2xvY2tf
dDsKI2VuZGlmCgojaWZuZGVmIF9DQUREUl9UCiNkZWZpbmUgX0NBRERSX1QKdHlwZWRlZiBfX2tl
cm5lbF9jYWRkcl90CWNhZGRyX3Q7CiNlbmRpZgoKLyogYnNkICovCnR5cGVkZWYgdW5zaWduZWQg
Y2hhcgkJdV9jaGFyOwp0eXBlZGVmIHVuc2lnbmVkIHNob3J0CQl1X3Nob3J0Owp0eXBlZGVmIHVu
c2lnbmVkIGludAkJdV9pbnQ7CnR5cGVkZWYgdW5zaWduZWQgbG9uZwkJdV9sb25nOwoKLyogc3lz
diAqLwp0eXBlZGVmIHVuc2lnbmVkIGNoYXIJCXVuY2hhcjsKdHlwZWRlZiB1bnNpZ25lZCBzaG9y
dAkJdXNob3J0Owp0eXBlZGVmIHVuc2lnbmVkIGludAkJdWludDsKdHlwZWRlZiB1bnNpZ25lZCBs
b25nCQl1bG9uZzsKCiNpZm5kZWYgX19CSVRfVFlQRVNfREVGSU5FRF9fCiNkZWZpbmUgX19CSVRf
VFlQRVNfREVGSU5FRF9fCgp0eXBlZGVmCQlfX3U4CQl1X2ludDhfdDsKdHlwZWRlZgkJX19zOAkJ
aW50OF90Owp0eXBlZGVmCQlfX3UxNgkJdV9pbnQxNl90Owp0eXBlZGVmCQlfX3MxNgkJaW50MTZf
dDsKdHlwZWRlZgkJX191MzIJCXVfaW50MzJfdDsKdHlwZWRlZgkJX19zMzIJCWludDMyX3Q7Cgoj
ZW5kaWYgLyogIShfX0JJVF9UWVBFU19ERUZJTkVEX18pICovCgp0eXBlZGVmCQlfX3U4CQl1aW50
OF90Owp0eXBlZGVmCQlfX3UxNgkJdWludDE2X3Q7CnR5cGVkZWYJCV9fdTMyCQl1aW50MzJfdDsK
CiNpZiBkZWZpbmVkKF9fR05VQ19fKQp0eXBlZGVmCQlfX3U2NAkJdWludDY0X3Q7CnR5cGVkZWYJ
CV9fdTY0CQl1X2ludDY0X3Q7CnR5cGVkZWYJCV9fczY0CQlpbnQ2NF90OwojZW5kaWYKCi8qIHRo
aXMgaXMgYSBzcGVjaWFsIDY0Yml0IGRhdGEgdHlwZSB0aGF0IGlzIDgtYnl0ZSBhbGlnbmVkICov
CiNkZWZpbmUgYWxpZ25lZF91NjQgX191NjQgX19hdHRyaWJ1dGVfXygoYWxpZ25lZCg4KSkpCiNk
ZWZpbmUgYWxpZ25lZF9iZTY0IF9fYmU2NCBfX2F0dHJpYnV0ZV9fKChhbGlnbmVkKDgpKSkKI2Rl
ZmluZSBhbGlnbmVkX2xlNjQgX19sZTY0IF9fYXR0cmlidXRlX18oKGFsaWduZWQoOCkpKQoKLyoq
CiAqIFRoZSB0eXBlIHVzZWQgZm9yIGluZGV4aW5nIG9udG8gYSBkaXNjIG9yIGRpc2MgcGFydGl0
aW9uLgogKgogKiBMaW51eCBhbHdheXMgY29uc2lkZXJzIHNlY3RvcnMgdG8gYmUgNTEyIGJ5dGVz
IGxvbmcgaW5kZXBlbmRlbnRseQogKiBvZiB0aGUgZGV2aWNlcyByZWFsIGJsb2NrIHNpemUuCiAq
CiAqIGJsa2NudF90IGlzIHRoZSB0eXBlIG9mIHRoZSBpbm9kZSdzIGJsb2NrIGNvdW50LgogKi8K
I2lmZGVmIENPTkZJR19MQkQKdHlwZWRlZiB1NjQgc2VjdG9yX3Q7CnR5cGVkZWYgdTY0IGJsa2Nu
dF90OwojZWxzZQp0eXBlZGVmIHVuc2lnbmVkIGxvbmcgc2VjdG9yX3Q7CnR5cGVkZWYgdW5zaWdu
ZWQgbG9uZyBibGtjbnRfdDsKI2VuZGlmCgovKgogKiBUaGUgdHlwZSBvZiBhbiBpbmRleCBpbnRv
IHRoZSBwYWdlY2FjaGUuICBVc2UgYSAjZGVmaW5lIHNvIGFzbS90eXBlcy5oCiAqIGNhbiBvdmVy
cmlkZSBpdC4KICovCiNpZm5kZWYgcGdvZmZfdAojZGVmaW5lIHBnb2ZmX3QgdW5zaWduZWQgbG9u
ZwojZW5kaWYKCiNlbmRpZiAvKiBfX0tFUk5FTF9TVFJJQ1RfTkFNRVMgKi8KCi8qCiAqIEJlbG93
IGFyZSB0cnVseSBMaW51eC1zcGVjaWZpYyB0eXBlcyB0aGF0IHNob3VsZCBuZXZlciBjb2xsaWRl
IHdpdGgKICogYW55IGFwcGxpY2F0aW9uL2xpYnJhcnkgdGhhdCB3YW50cyBsaW51eC90eXBlcy5o
LgogKi8KCiNpZmRlZiBfX0NIRUNLRVJfXwojZGVmaW5lIF9fYml0d2lzZV9fIF9fYXR0cmlidXRl
X18oKGJpdHdpc2UpKQojZWxzZQojZGVmaW5lIF9fYml0d2lzZV9fCiNlbmRpZgojaWZkZWYgX19D
SEVDS19FTkRJQU5fXwojZGVmaW5lIF9fYml0d2lzZSBfX2JpdHdpc2VfXwojZWxzZQojZGVmaW5l
IF9fYml0d2lzZQojZW5kaWYKCnR5cGVkZWYgX191MTYgX19iaXR3aXNlIF9fbGUxNjsKdHlwZWRl
ZiBfX3UxNiBfX2JpdHdpc2UgX19iZTE2Owp0eXBlZGVmIF9fdTMyIF9fYml0d2lzZSBfX2xlMzI7
CnR5cGVkZWYgX191MzIgX19iaXR3aXNlIF9fYmUzMjsKdHlwZWRlZiBfX3U2NCBfX2JpdHdpc2Ug
X19sZTY0Owp0eXBlZGVmIF9fdTY0IF9fYml0d2lzZSBfX2JlNjQ7Cgp0eXBlZGVmIF9fdTE2IF9f
Yml0d2lzZSBfX3N1bTE2Owp0eXBlZGVmIF9fdTMyIF9fYml0d2lzZSBfX3dzdW07CgoKI2VuZGlm
IC8qIF9MSU5VWF9UWVBFU19IICovCg==
--0016e64dd4ced083a704605ce9dc--
