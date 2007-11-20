Return-Path: <linux-kernel-owner+w=401wt.eu-S1765079AbXKTXwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765079AbXKTXwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764965AbXKTXvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:51:45 -0500
Received: from www.tglx.de ([62.245.132.106]:50409 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760782AbXKTXvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:51:44 -0500
Date: Wed, 21 Nov 2007 00:50:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: <20071120232715.0803426F8BE@magilla.localdomain>
Message-ID: <alpine.LFD.0.9999.0711210048020.25057@localhost.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220425.6002E26F8BE@magilla.localdomain> <alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain> <20071120205759.3533A26F8BE@magilla.localdomain> <alpine.LFD.0.9999.0711202348470.25057@localhost.localdomain>
 <20071120232715.0803426F8BE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Roland McGrath wrote:

> > git format-patch -p
> > 
> > does the trick at least here :)
> 
> Ok, I can use that in future.  I hope it still means that in the eventual
> merged state, GIT will be aware of all the renames.

git does not store the "renamed/copied" info at all. That's just an
optimization. It does not matter if you use git-mv or just apply a
patch which does the same. git figures that out by looking at the
changes AFAICT, but not by storing metadata which keeps track of this.

Thanks,

	tglx
