Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbXFYBct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbXFYBct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXFYBcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:32:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38865 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347AbXFYBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:32:41 -0400
Date: Mon, 25 Jun 2007 03:33:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
Message-ID: <20070625013302.GB1094@stusta.de>
References: <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1182733127.6819.13.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 05:58:46PM -0700, Arjan van de Ven wrote:
> 
> > I wouldn't care if CONFIG_CC_OPTIMIZE_FOR_SIZE was hidden behind
> > CONFIG_EMBEDDED, but as long as it's available as a general purpose
> > option we have to consider it's performance.
> 
> I think you are missing the point. You tell the kernel to
> OPTIMIZE_FOR_SIZE. *over performance*. Sure. Performance shouldn't be
> EXTREMELY pathetic, but it's not; and if it were, it's a problem with
> the gcc version you have (and if you are a distro, you can surely fix
> that)

My point is commit c45b4f1f1e149c023762ac4be166ead1818cefef

CC_OPTIMIZE_FOR_SIZE is currently known as an experimental feature to 
improve the _performance_.

> > The interesting questions are:
> > Does -Os still sometimes generate faster code with gcc 4.2?
> > If yes, why?
> 
> on a system level, size can help performance because you have more
> memory available for other things.

For a given gcc version, there's a finite number of differences between 
-Os and -O2. 

The interesting question is for which differences with gcc 4.2 we want 
the -Os version in the kernel for best performance. This should then be 
controllable through gcc options.

> It also reduces download size and 
> gives you more space on the live CD....

That's a different point.

If you don't care about performance but care about size then -Os is 
the best choice.

> if you want to make things bigger again, please do this OUTSIDE the
> "optimize for size" option. Because that TELLS you to go for size.

Agreed, but CONFIG_CC_OPTIMIZE_FOR_SIZE should again be under 
CONFIG_EMBEDDED.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

