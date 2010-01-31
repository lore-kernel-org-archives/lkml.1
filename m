Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394Ab0AaTCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0AaTCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 14:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593Ab0AaTCp
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 14:02:45 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:61572 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0AaTCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 14:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xeav335Qw42ZOI+zjT83OHI74zUOiisYpjTrLwznbR8tT0LiT6GTUddb1RtP0NiOIU
         uhkV/rne3eBQ5Tgaycj78uScOcsUAUrHZ/deQ5NOCTbjFuc5cG9fhBg8Ebo+Zb7ZFgik
         Ehx6htWZKHwOd+6LQt7OTEwHIjN60/sTPCoRk=
MIME-Version: 1.0
In-Reply-To: <1264884670-28211-2-git-send-email-jkacur@redhat.com>
References: <1264884670-28211-1-git-send-email-jkacur@redhat.com>
	 <1264884670-28211-2-git-send-email-jkacur@redhat.com>
Date: Sun, 31 Jan 2010 11:02:43 -0800
Message-ID: <91705d081001311102m63cb3edfib8df864ca580e736@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gcmFkZW9uX2FncDogRml4IHdhcm5pbmcsIGZvcm1hdCDigJglZOKAmQ==?=
	=?UTF-8?B?IGV4cGVjdHMgdHlwZSDigJhpbnTigJksIGJ1dCBhcmd1bWVudCA0IGhhcyB0eXBlIOKAmHNpemVfdA==?=
	=?UTF-8?B?4oCZ?=
From: Dan Nicholson <dbn.lists@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jerome Glisse <jglisse@redhat.com>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 12:51 PM, John Kacur <jkacur@redhat.com> wrote:
> Fix warning by using %zu instead of %d for size_t
>
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  drivers/gpu/drm/radeon/radeon_agp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
> index c9ad7f5..1c4e523 100644
> --- a/drivers/gpu/drm/radeon/radeon_agp.c
> +++ b/drivers/gpu/drm/radeon/radeon_agp.c
> @@ -134,7 +134,7 @@ int radeon_agp_init(struct radeon_device *rdev)
>        int ret;
>
>        if (rdev->ddev->agp->agp_info.aper_size < 32) {
> -               dev_warn(rdev->dev, "AGP aperture to small (%dM) "
> +               dev_warn(rdev->dev, "AGP aperture to small (%zuM) "

As long as you're fixing this line, you might want to correct the
grammar s/to/too/.

--
Dan
