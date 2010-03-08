Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0CHPAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:00:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41905 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0CHPAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:00:46 -0500
Date: Mon, 8 Mar 2010 09:47:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ps3_gelic_wireless: fix format warning
Message-ID: <20100308144702.GA20622@tuxdriver.com>
References: <201003022006.o22K6QqH019931@hera.kernel.org> <10f740e81003072233j1f9f6a0fr633e1fc65f4e5a5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10f740e81003072233j1f9f6a0fr633e1fc65f4e5a5a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 07:33:27AM +0100, Geert Uytterhoeven wrote:
> On Tue, Mar 2, 2010 at 21:06, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
> > Gitweb:     http://git.kernel.org/linus/c6c97bdaa3307d0811f14c99c38c63a8dae36e1f
> > Commit:     c6c97bdaa3307d0811f14c99c38c63a8dae36e1f
> > Parent:     d3a571971e5af241074947fc80f6284677f6e014
> > Author:     John W. Linville <linville@tuxdriver.com>
> > AuthorDate: Mon Feb 1 09:55:56 2010 -0500
> > Committer:  John W. Linville <linville@tuxdriver.com>
> > CommitDate: Mon Feb 1 09:55:56 2010 -0500
> >
> >    ps3_gelic_wireless: fix format warning
> >
> >    Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/ps3_gelic_wireless.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
> > index d520e9e..448c5b6 100644
> > --- a/drivers/net/ps3_gelic_wireless.c
> > +++ b/drivers/net/ps3_gelic_wireless.c
> > @@ -1449,7 +1449,7 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
> >        void *buf = NULL;
> >        size_t len;
> >
> > -       pr_debug("%s: <- always=%d essid_len=%d\n", __func__,
> > +       pr_debug("%s: <- always=%d essid_len=%z\n", __func__,
> 
> `z' is just a modifier for a (missing) type, so this should be `%zu'.

Ugh...yes, correct.  I'll fix it.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
