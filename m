Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZIVHS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZIVHS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZIVHS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:18:27 -0400
Received: from mail-pz0-f173.google.com ([209.85.222.173]:56166 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZIVHS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=hovkoXs0Gdvh0SOQByKDCvf4MsfsT6BTIjDD7IKzEj3yNj2MzmItp2jxVUAwa1iJpg
         ZS9CMaOV6pqb+titWW7zCRIwPiTACG/rEP5nO7Pt5xapXYABjdufhTVg5qOZfqt48Kb8
         mTLcFa8SbMZEgQsY5KuTaSICc/siXPNsQl2kY=
MIME-Version: 1.0
In-Reply-To: <3877989d0909220017l61394c3cy769e95656db70d22@mail.gmail.com>
References: <3877989d0909220017l61394c3cy769e95656db70d22@mail.gmail.com>
Date: Tue, 22 Sep 2009 15:18:29 +0800
Message-ID: <3877989d0909220018x4233cbdx99359cc45e5c2153@mail.gmail.com>
Subject: Re: [RFC PATCH] delete unnecessary BUG_ON !policy->cur
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd32874b38e580474256723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd32874b38e580474256723
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Patch attached!

On Tue, Sep 22, 2009 at 3:17 PM, Luming Yu <luming.yu@gmail.com> wrote:
> Hi there,
>
> When testing upstream Git tree, there is a BUG_ON hit on a IA64 system
> with RHEL 5 user space installed.
> Please review the patch below, If make sense, please apply.
>
> Ps. The patch is enclosed in attachment. The inlined one
> is c&p of it for reading.
>
>
> Thanks,
> Luming
>
> Signed-off-by: Yu Luming <luming.yu@intel.com>
>
> =C2=A0cpufreq_userspace.c | =C2=A0 =C2=A01 -
> =C2=A01 file changed, 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_userspace.c
> b/drivers/cpufreq/cpufreq_userspace.c
> index 66d2d1d..63bd232 100644
> --- a/drivers/cpufreq/cpufreq_userspace.c
> +++ b/drivers/cpufreq/cpufreq_userspace.c
> @@ -119,7 +119,6 @@ static int cpufreq_governor_userspace(st
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case CPUFREQ_GOV_START:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cpu_online(cp=
u))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -EINVAL;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(!policy->cur);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&usersp=
ace_mutex);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cpus_using_use=
rspace_governor =3D=3D 0) {
>

--000e0cd32874b38e580474256723
Content-Type: application/octet-stream; name="10.patch"
Content-Disposition: attachment; filename="10.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzwbnfil0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX3VzZXJzcGFjZS5jIGIvZHJpdmVy
cy9jcHVmcmVxL2NwdWZyZXFfdXNlcnNwYWNlLmMKaW5kZXggNjZkMmQxZC4uNjNiZDIzMiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfdXNlcnNwYWNlLmMKKysrIGIvZHJpdmVy
cy9jcHVmcmVxL2NwdWZyZXFfdXNlcnNwYWNlLmMKQEAgLTExOSw3ICsxMTksNiBAQCBzdGF0aWMg
aW50IGNwdWZyZXFfZ292ZXJub3JfdXNlcnNwYWNlKHN0CiAJY2FzZSBDUFVGUkVRX0dPVl9TVEFS
VDoKIAkJaWYgKCFjcHVfb25saW5lKGNwdSkpCiAJCQlyZXR1cm4gLUVJTlZBTDsKLQkJQlVHX09O
KCFwb2xpY3ktPmN1cik7CiAJCW11dGV4X2xvY2soJnVzZXJzcGFjZV9tdXRleCk7CiAKIAkJaWYg
KGNwdXNfdXNpbmdfdXNlcnNwYWNlX2dvdmVybm9yID09IDApIHsK
--000e0cd32874b38e580474256723--
