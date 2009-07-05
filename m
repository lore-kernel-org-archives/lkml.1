Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZGEO4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZGEO4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZGEO4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:56:22 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:8128 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbZGEO4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:56:22 -0400
Date: Sun, 5 Jul 2009 17:05:47 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       =?UTF-8?Q?=E6=99=8F=E5=8D=8E?= <yanh@lemote.com>,
       zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by
 "fbdev: add mutex for fb_mmap locking"
Message-Id: <20090705170547.c83f1cb9.krzysztof.h1@poczta.fm>
In-Reply-To: <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain>
References: <1246785112.14240.34.camel@falcon>
	<alpine.LFD.2.01.0907050715490.3210@localhost.localdomain>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: e6e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009 07:19:33 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 5 Jul 2009, Wu Zhangjin wrote:
> > 
> > then it works! so, I guess there is a deadlock introduced by the above
> > commit.
> 
> Hmm. Perhaps more likely, the 'mm_lock' mutex hasn't even been initialized 
> yet.  We appear to have had that problem with matroxfb and sm501fb, and it 
> may be more common than that. See commit f50bf2b2.
> 
> That said, I do agree that the mm_lock seems to be causing more problems 
> than it actually fixes, and maybe we should revert it. Krzysztof?
> 

I vote for fixing these drivers after my change. I will send a patch for the sis driver soon. I am building new kernel now.

Regards,
Krzysztof

----------------------------------------------------------------------
Rozwiaz krzyzowke i  wygraj nagrody! 
Sprawdz >>  http://link.interia.pl/f2232 

