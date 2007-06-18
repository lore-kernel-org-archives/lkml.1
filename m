Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbXFRHsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbXFRHsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXFRHrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:47:55 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38138 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbXFRHrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:47:55 -0400
Date: Mon, 18 Jun 2007 09:48:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: More __meminit annotations.
Message-ID: <20070618074858.GB21222@uranus.ravnborg.org>
References: <20070618143943.B108.Y-GOTO@jp.fujitsu.com> <20070618055842.GA17858@linux-sh.org> <20070618151544.B10A.Y-GOTO@jp.fujitsu.com> <a781481a0706172357s7c473686pa41df174af01cda4@mail.gmail.com> <a781481a0706180028k5d44f27eld7c2d2564c42ed63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706180028k5d44f27eld7c2d2564c42ed63@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 12:58:34PM +0530, Satyam Sharma wrote:
> 
> Actually, modpost will _not_ complain precisely _because_ kernel
> uses always_inline so a separate body for the function will never be
> emitted at all.
That has been threaten to change many times. Far far far too much
are marked inline today. There has been several longer threads about it.

Part of it is that some part MUST be inlined to work while other parts
may be inline but not needed (and often the wrong thing).

So a carefully added inline is good but the other 98% of inline
markings are just wrong and ougth to go.

	Sam
