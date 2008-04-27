Return-Path: <linux-kernel-owner+w=401wt.eu-S1763743AbYD0Xh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763743AbYD0Xh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYD0Xhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:37:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbYD0Xht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:37:49 -0400
Date: Sun, 27 Apr 2008 16:36:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
 architectures
In-Reply-To: <20080427162606.3dd82c0c@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.1.10.0804271634490.3119@woody.linux-foundation.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org>
 <20080427174714.GB2252@cs181133002.pp.htv.fi> <20080427180007.GB28483@infradead.org> <20080427180957.GA25964@uranus.ravnborg.org> <20080427181411.GA31667@infradead.org> <alpine.LFD.1.10.0804271118500.2896@woody.linux-foundation.org>
 <20080427162606.3dd82c0c@laptopd505.fenrus.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2008, Arjan van de Ven wrote:
> 
> (actually, other than some obscure commandline options, the only sane way to
> avoid gcc doing this too agressive is using -Os)

Well, CC_OPTIMIZE_FOR_SIZE has been defaulting to 'y' for a *loong* time, 
but it's hidden behind a EXPERIMENTAL (unless you were on some embedded 
architectures), so many people won't see it.

Perhaps it is time to remove the EXPERIMENTAL? I think the gcc warnings 
were mostly bogus - it's not as if there haven't been compiler bugs 
without -Os too..

		Linus
