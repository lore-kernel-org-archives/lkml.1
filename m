Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbXIJOPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbXIJOPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbXIJOPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:15:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60611 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477AbXIJOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:15:16 -0400
Date: Mon, 10 Sep 2007 16:14:56 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910161456.7431312c@laptopd505.fenrus.org>
In-Reply-To: <20070910022324.c69e1897.akpm@linux-foundation.org>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
	<20070909145940.0b41c8a5.akpm@linux-foundation.org>
	<20070910090808.GA31204@infradead.org>
	<20070910022324.c69e1897.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 02:23:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I would like to see "everyone" explain what we lose by giving
> developers a bit of warning before we break their stuff.

here's the skinny: 99% of the external module developers won't notice
until they're gone, even with the warning. And that's an optimistic
estimate. Warnings don't work for this.

All this kind of thing buys us is an excuse so that we can say "but we
warned  you for 3 months". It doesn't actually change anything else.

Maybe I'm too pessimistic in my assumption that external open module
writers don't actually follow mainline closely; and maybe part of me
would love for them to follow it closer, so close that they would even
consider submitting their driver for it. But sadly from experience...
warnings dont' work. Only when things break hard people notice.
