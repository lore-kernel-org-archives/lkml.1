Return-Path: <linux-kernel-owner+w=401wt.eu-S1765633AbZDHNiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765633AbZDHNiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765566AbZDHNhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:37:25 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:50929 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765451AbZDHNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:37:23 -0400
Date: Wed, 8 Apr 2009 15:36:19 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Jack Stone <jwjstone@fastmail.fm>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeff@garzik.org" <jeff@garzik.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 08/56] cris: Remove void casts
Message-ID: <20090408133619.GJ8115@axis.com>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080534g54a1d4f3ue782b8598d238090@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36ca99e90904080534g54a1d4f3ue782b8598d238090@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:34:12PM +0200, Bert Wesarg wrote:
> On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
> > Remove uneeded void casts
> >
> > Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> > ---
> >  arch/cris/arch-v32/drivers/cryptocop.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
> > index 67c61ea..5d20327 100644
> > --- a/arch/cris/arch-v32/drivers/cryptocop.c
> > +++ b/arch/cris/arch-v32/drivers/cryptocop.c
> > @@ -2455,7 +2455,7 @@ static int map_pages_to_iovec(struct iovec *iov, int iovlen, int *iovix, struct
> >                        DEBUG_API(printk("map_page_to_iovec: *pageix=%d >= nopages=%d\n", *pageix, nopages));
> >                        return 0;
> >                }
> > -               iov[*iovix].iov_base = (unsigned char*)page_address(pages[*pageix]) + *pageoffset;
> > +               iov[*iovix].iov_base = page_address(pages[*pageix]) + *pageoffset;
> Pointer arithmetic or intended cast (to avoid warnings for void
> pointer arithmetic).

Good catch. I think I'll drop the patch for now.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
