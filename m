Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbXBYGDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbXBYGDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 01:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXBYGDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 01:03:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbXBYGDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 01:03:46 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070225054342.GA7941@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070220145503.GC3170@thunk.org>
	 <1171984555.3518.5.camel@hades.cambridge.redhat.com>
	 <20070225054342.GA7941@infradead.org>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 01:04:13 -0500
Message-Id: <1172383453.18032.12.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 05:43 +0000, Christoph Hellwig wrote:
> > The technique Artem uses is derived from what I do in JFFS2. It predates
> > the use of sparse to catch such errors, and works in gcc for _everyone_
> > without having to do anything special (like run sparse).
> 
> And makes the code clumsy and pointlessly different from all other code
> we have. 

I would suggest that it's not any more clumsy; the implementation is
fairly obvious and the _use_ of it is just the same. But I won't bother,
because it's largely pointless to compare something functional with
something non-functional.

>  If you really want warnings from gcc directly I doubt
>  __attribute__((bitwise)) would be hard to implement for it. 

I have warnings from GCC already, thank you very much. I see no
particular reason to hack on the compiler to give me new ways of
achieving what I've already had for years. But if someone else were to
do so I'd have no particular objection to switching over to using it.
Let's see it merged first though, before you suggest that people should
use it instead of what actually _works_ today.

-- 
dwmw2

