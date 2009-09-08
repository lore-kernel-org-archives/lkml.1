Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZIHQcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZIHQcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZIHQcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:32:35 -0400
Received: from mail.atheros.com ([12.36.123.2]:49998 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZIHQce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:32:34 -0400
Date: Tue, 8 Sep 2009 09:32:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: slab tree build failure
Message-ID: <20090908163236.GB8839@mosca>
References: <20090907153723.0c984c83.sfr@canb.auug.org.au>
 <84144f020909062310u37ecdddfw31c6cc9a22ccabd9@mail.gmail.com>
 <1252312509.23780.15.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1252312509.23780.15.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 01:35:09AM -0700, Catalin Marinas wrote:
> On Mon, 2009-09-07 at 09:10 +0300, Pekka Enberg wrote:
> > Hi Stephen,
> >
> > On Mon, Sep 7, 2009 at 8:37 AM, Stephen Rothwell<sfr@canb.auug.org.au> wrote:
> > > Hi all,
> > >
> > > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > >
> > > net/wireless/scan.c: In function 'cfg80211_inform_bss':
> > > net/wireless/scan.c:499: error: implicit declaration of function 'kmemleak_ignore'
> > >
> > > Caused by commit 74ce35c0d2261896ed4d49799311a894520f7a94 ("cfg80211:
> > > clear cfg80211_inform_bss() from kmemleak reports") from the wireless
> > > tree (which should have included linux/kmemleak.h into
> > > net/wireless/scan.c).  Some interaction with the slab tree has exposed
> > > this.
> > >
> > > I have reverted the above commit for today.
> >
> > AFAICT, you're interested in kmemleak.git, not slab.git. Catalin?
> 
> I think that's a commit from Luis. It shouldn't have been merged in the
> first instance anyway (we shouldn't randomly ignore kmemleak reports
> unless we know for sure why kmemleak thinks it is a leak and we should
> write a comment explaining why).

I asked John to revert it, feel free to do the same.

  Luis
