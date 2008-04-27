Return-Path: <linux-kernel-owner+w=401wt.eu-S1763802AbYD0TuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763802AbYD0TuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762747AbYD0TuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:50:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60753 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbYD0TuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:50:09 -0400
Date: Sun, 27 Apr 2008 22:49:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427194939.GE2252@cs181133002.pp.htv.fi>
References: <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <20080427180007.GB28483@infradead.org> <20080427180957.GA25964@uranus.ravnborg.org> <20080427181411.GA31667@infradead.org> <alpine.LFD.1.10.0804271118500.2896@woody.linux-foundation.org> <20080427193627.GA32654@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080427193627.GA32654@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 09:36:27PM +0200, Ingo Molnar wrote:
>...
> and a third aspect is that in the current -git kernel we have exactly 
> 11801 inlines in non-include files. Fighting the constant influx of them 
> was a futile act 3 years ago when Arjan and me created this feature for 
> the first time and it is futile today. It is a compiler domain problem 
> and we should not waste any manpower "fighting" them. Life is too short :)

It is a kernel bug that we have inline's at the wrong places.

I will "waste" my manpower on fixing these bugs.

It is a well-known fact that much code that gets added to the kernel is 
crap, but that shouldn't be an excuse for not fixing bugs in the kernel.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

