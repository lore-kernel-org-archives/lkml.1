Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbYD0Sbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbYD0Sbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbYD0Sbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:31:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759061AbYD0Sbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:31:38 -0400
Date: Sun, 27 Apr 2008 11:30:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
 architectures
In-Reply-To: <20080427182544.GA23828@infradead.org>
Message-ID: <alpine.LFD.1.10.0804271128480.2896@woody.linux-foundation.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org>
 <20080427174714.GB2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271053300.2896@woody.linux-foundation.org> <20080427182544.GA23828@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2008, Christoph Hellwig wrote:
> 
> Actually looking at older code in the tree he's most likely wrong :)
> Probably as bad as the compiler.  But the nice part about the code is
> that we can fix it easily.

Good point.

It *would* be really interesting to have some way to check our assumptions 
(both ways - warn about over-large inlines and small-and-hot non-inlines). 

I considered making sparse give some size estimate for inlines and warn 
about ones that generate a lot of code, but I was never able to do it 
sanely.

			Linus
