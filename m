Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428Ab0AaTa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0AaTa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 14:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216Ab0AaTa6
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 14:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0AaTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 14:30:58 -0500
Date: Sun, 31 Jan 2010 20:29:21 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Dan Nicholson <dbn.lists@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jerome Glisse <jglisse@redhat.com>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: =?ISO-8859-7?Q?Re=3A_=5BPATCH=5D_radeon=5Fagp=3A_Fix_warning=2C_format_=A1%d=A2_expects_type_=A1int=A2=2C_but_argument_4_has_type_=A1size=5Ft=A2?=
In-Reply-To: <91705d081001311102m63cb3edfib8df864ca580e736@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001312028130.17637@localhost.localdomain>
References: <1264884670-28211-1-git-send-email-jkacur@redhat.com>  <1264884670-28211-2-git-send-email-jkacur@redhat.com> <91705d081001311102m63cb3edfib8df864ca580e736@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-145763144-1264966167=:17637"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-145763144-1264966167=:17637
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Sun, 31 Jan 2010, Dan Nicholson wrote:

> On Sat, Jan 30, 2010 at 12:51 PM, John Kacur <jkacur@redhat.com> wrote:
> > Fix warning by using %zu instead of %d for size_t
> >
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  drivers/gpu/drm/radeon/radeon_agp.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
> > index c9ad7f5..1c4e523 100644
> > --- a/drivers/gpu/drm/radeon/radeon_agp.c
> > +++ b/drivers/gpu/drm/radeon/radeon_agp.c
> > @@ -134,7 +134,7 @@ int radeon_agp_init(struct radeon_device *rdev)
> >        int ret;
> >
> >        if (rdev->ddev->agp->agp_info.aper_size < 32) {
> > -               dev_warn(rdev->dev, "AGP aperture to small (%dM) "
> > +               dev_warn(rdev->dev, "AGP aperture to small (%zuM) "
> 
> As long as you're fixing this line, you might want to correct the
> grammar s/to/too/.

Thanks, I saw that too, after I sent. Unfortunately, I have to respin both 
patches, because there is a merge conflict after fixing the 
grammar/spelling mistake.

Both patches coming up, in a separate mail.

John
--8323328-145763144-1264966167=:17637--
