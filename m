Return-Path: <linux-kernel-owner+w=401wt.eu-S1763249AbYD0SZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763249AbYD0SZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbYD0SZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:25:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbYD0SZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:25:48 -0400
Date: Sun, 27 Apr 2008 14:25:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427182544.GA23828@infradead.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271053300.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804271053300.2896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:11:27AM -0700, Linus Torvalds wrote:
> For example, what's wrong with having "inline" on functions in .c files if 
> the author thinks they are small enough? He's likely right. Considering 
> past behaviour, he's quite often more right than the compiler.

Actually looking at older code in the tree he's most likely wrong :)
Probably as bad as the compiler.  But the nice part about the code is
that we can fix it easily.

