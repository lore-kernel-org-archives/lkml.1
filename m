Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbXFYAkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbXFYAkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXFYAkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:40:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38826 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751376AbXFYAkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:40:46 -0400
Date: Mon, 25 Jun 2007 02:41:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>, linux-kernel@vger.kernel.org
Subject: -Os versus -O2
Message-ID: <20070625004106.GA1094@stusta.de>
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1182731022.6819.10.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 05:23:42PM -0700, Arjan van de Ven wrote:
> On Sun, 2007-06-24 at 20:12 -0400, Benjamin LaHaise wrote:
> > On Sun, Jun 24, 2007 at 05:09:16PM -0700, Arjan van de Ven wrote:
> > > if you care about the last cycle, don't specify -Os but -O2.
> > > simple as that... you get what you tell the compiler you want.
> > 
> > Certain distros are shipping kernels compiled with -Os.  And it's more 
> > than just a couple of cycles.
> 
> so those distros pick space over some cycles. Who are you to then
> override that choice ? ;-)
> 
> seriously, why are we even talking about overriding a choice the user
> (or distro vendor as user) made here?

There is a real issue in the fact that compiling with -Os is available
through a kconfig option and AFAIR used by some distributions.

I doubt distros enable CONFIG_CC_OPTIMIZE_FOR_SIZE due to size 
considerations, but due to speed considerations.

I wouldn't care if CONFIG_CC_OPTIMIZE_FOR_SIZE was hidden behind
CONFIG_EMBEDDED, but as long as it's available as a general purpose
option we have to consider it's performance.

The interesting questions are:
Does -Os still sometimes generate faster code with gcc 4.2?
If yes, why?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

