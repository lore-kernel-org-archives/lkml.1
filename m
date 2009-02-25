Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbZBYKiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbZBYKiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZBYKhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:37:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:34190 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZBYKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:37:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y7Y37qFbvGYLIbeDAKlC0gDqNxXNfw0Pdv0OADPRjElkPSwIoBTTrAYcwgTsV80kYo
         G+6l1mU4hxhZvY2EtKGmQeY9IU/yckSeQXBJAqqz9k/NBJtFtL8KUmmtmTn1DsB9uDHe
         2+JpzXPGcoeldhXI+UNMLCHzhuRWe1wnDImxA=
MIME-Version: 1.0
In-Reply-To: <49A51B4D.5070903@Free.fr>
References: <49A51B4D.5070903@Free.fr>
Date: Wed, 25 Feb 2009 20:37:50 +1000
Message-ID: <21d7e9970902250237i13f20336ib0176ed2b0edd7f4@mail.gmail.com>
Subject: Re: Some user feedback on recent Intel chipset and 2.6.29 KMS
From: Dave Airlie <airlied@gmail.com>
To: Eric.Valette@free.fr
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636499441d6bed70463bbd37c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636499441d6bed70463bbd37c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 25, 2009 at 8:19 PM, Eric Valette <Eric.Valette@free.fr> wrote:
> Hi,
>
> Thanks for the nice work: for the first time (starting with
> 2.6.29-rc6-git1), I managed to remove the vesa framebuffer in favor of
> intel's ones. =A0Recent X server (1.5.99.902 + git intel driver and git
> drm) also comes up correctly and detects the KMS.
>
> This amilo xi 3650 is a transportable SLI enabled laptop with Nvidia
> GeForce 9600M GT & Mobile Intel=AE GM45 Express Chipset. By defaut the
> Intel card is active. I can force using one or other in the bios but
> expects one day I will be able to be able to dynamically switch like on
> vista.
>
> However there are still some problem with drm, Xorg, suspend/resume:
>
> =A0 1. The X server needs interrupts (mouse or keyboard) to redraw things
> =A0 =A0 =A0(e.g if I do apt-get update in a konsole, I see it freeeze but=
 if
> =A0 =A0 =A0I move the mouse I get the complete output instantly. Same thi=
ng
> =A0 =A0 =A0when I start a new application, I have to hit shift or move mo=
use.
> =A0 =A0 =A0The same user land setting with 2.6.28.7 behaves correctly,
> =A0 2. I have a lot of problem with suspend to ram: when console comes up
> =A0 =A0 =A0but with a cyan background and then X comes up completely garb=
led
> =A0 =A0 =A0although I can distinguish some shadow of the windows and a
> =A0 =A0 =A0konsole is still active if I enter init 0. Sometimes it purely
> =A0 =A0 =A0freeze. If I switch back to tty (when I can), and restart kdm,
> =A0 =A0 =A0then it starts only in 800x600 mode. Using krandrtray to put i=
t
> =A0 =A0 =A0back at 1920x1080, it simply freezes.
>

See if the attached patch helps resume, there are also some other patches
queued for Linus in my drm-fixes tree. I sent the pull req earlier.

Dave.

> If I can help testing anything, providing traces (dmesg, config, lspci,
> xorg config) let me know.
>
> PS: CC me if anwering to the list I'm not suscribed.
>
> -- eric
>

--001636499441d6bed70463bbd37c
Content-Type: application/octet-stream; name=mypatch
Content-Disposition: attachment; filename=mypatch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_frlvgcpv0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2LmMgYi9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pOTE1X2Rydi5jCmluZGV4IGIyOTNlZjAuLjA4M2ViMWQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2LmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaTkxNV9kcnYuYwpAQCAtMTAzLDYgKzEwMyw5IEBAIHN0YXRpYyBpbnQgaTkxNV9yZXN1bWUo
c3RydWN0IGRybV9kZXZpY2UgKmRldikKIAogCS8qIEtNUyBFbnRlclZUIGVxdWl2YWxlbnQgKi8K
IAlpZiAoZHJtX2NvcmVfY2hlY2tfZmVhdHVyZShkZXYsIERSSVZFUl9NT0RFU0VUKSkgeworCisJ
CWRybV9oZWxwZXJfcmVzdW1lX2ZvcmNlX21vZGUoZGV2KTsKKwogCQltdXRleF9sb2NrKCZkZXYt
PnN0cnVjdF9tdXRleCk7CiAJCWRldl9wcml2LT5tbS5zdXNwZW5kZWQgPSAwOwogCg==
--001636499441d6bed70463bbd37c--
