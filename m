Return-Path: <linux-kernel-owner+w=401wt.eu-S1751296AbZLRIo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbZLRIo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZLRIo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:44:28 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:12106 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZLRIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:44:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JXVUbMRj1BMBm1H8z8JiRVXqJhmO5e2mACRyGF69IDSzHmaEOMfqpgsU3DhSqcZIyj
         JOlmgP1iVCqFVnytJTc8uXJlfe2URvqXlF8ySnRx76fH6iXPYFbLdEnmObuNT1oGTLUk
         dinPl+VKYEGrym7mEppkaDEsoOKqPy3ba+JjU=
MIME-Version: 1.0
In-Reply-To: <4B2B3EAF.2040302@gmail.com>
References: <4B2B3EAF.2040302@gmail.com>
Date: Fri, 18 Dec 2009 16:44:27 +0800
Message-ID: <2375c9f90912180044x64620edex532bba96952882dd@mail.gmail.com>
Subject: Re: [x86]compile error
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Content-Type: multipart/mixed; boundary=0015175767bc53457d047afcbfa6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175767bc53457d047afcbfa6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18, 2009 at 4:34 PM, Helight.Xu <helight.xu@gmail.com> wrote:
> linux@linux-desktop:~/linux-2.6$ make modules
> =C2=A0CHK =C2=A0 =C2=A0 include/linux/version.h
> =C2=A0CHK =C2=A0 =C2=A0 include/linux/utsrelease.h
> =C2=A0SYMLINK include/asm -> include/asm-x86
> =C2=A0CALL =C2=A0 =C2=A0scripts/checksyscalls.sh
> =C2=A0Building modules, stage 2.
> =C2=A0MODPOST 1834 modules
> ERROR: "snd_card_create" [drivers/platform/x86/thinkpad_acpi.ko] undefine=
d!
> ERROR: "snd_ctl_notify" [drivers/platform/x86/thinkpad_acpi.ko] undefined=
!
> ERROR: "snd_ctl_boolean_mono_info" [drivers/platform/x86/thinkpad_acpi.ko=
]
> undefined!
> ERROR: "snd_ctl_new1" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_card_free" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_card_register" [drivers/platform/x86/thinkpad_acpi.ko]
> undefined!
> ERROR: "snd_ctl_add" [drivers/platform/x86/thinkpad_acpi.ko] undefined!

Does attached patch fix your problem?

--0015175767bc53457d047afcbfa6
Content-Type: text/plain; charset=US-ASCII; 
	name="drivers-platform-x86-thinkpad-kconfig-fix.diff"
Content-Disposition: attachment; 
	filename="drivers-platform-x86-thinkpad-kconfig-fix.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3cpv8p10

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L0tjb25maWcgYi9kcml2ZXJzL3BsYXRm
b3JtL3g4Ni9LY29uZmlnCmluZGV4IGZjNWJmOWQuLjU5Njk2NmMgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvcGxhdGZvcm0veDg2L0tjb25maWcKKysrIGIvZHJpdmVycy9wbGF0Zm9ybS94ODYvS2NvbmZp
ZwpAQCAtMjE1LDYgKzIxNSw3IEBAIGNvbmZpZyBUSElOS1BBRF9BQ1BJCiAJZGVwZW5kcyBvbiBB
Q1BJCiAJZGVwZW5kcyBvbiBJTlBVVAogCWRlcGVuZHMgb24gUkZLSUxMIHx8IFJGS0lMTCA9IG4K
KwlkZXBlbmRzIG9uIFNPVU5ECiAJc2VsZWN0IEJBQ0tMSUdIVF9MQ0RfU1VQUE9SVAogCXNlbGVj
dCBCQUNLTElHSFRfQ0xBU1NfREVWSUNFCiAJc2VsZWN0IEhXTU9OCg==
--0015175767bc53457d047afcbfa6--
