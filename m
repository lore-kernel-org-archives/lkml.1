Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbYD1Ljr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbYD1Ljr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbYD1Ljj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:39:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763163AbYD1Lji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:39:38 -0400
Date: Mon, 28 Apr 2008 07:39:32 -0400
From: ext ext Christoph Hellwig <hch@infradead.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: ext ext Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@yandex.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Message-ID: <20080428113932.GA27250@infradead.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <20080426093553.GA17730@infradead.org> <48157812.5090909@nokia.com> <20080428090032.GA14100@infradead.org> <4815B3AE.5010500@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815B3AE.5010500@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:23:26PM +0300, Adrian Hunter wrote:
>>>> But these don't make much sense to me. Why would you want to be able
>>>> to compile out printks at this granularity? Why not enable all of them
>>>> when CONFIG_UBIFS_FS_DEBUG is enabled? 
>>>
>>> Well, its just more convenient for us. If I know the bug is somewhere in
>>> the journal, I enable the journal messages - less flooding. We may
>>> lessen the amount, but it is still handy to have some classes of
>>> prints separate.
>>>
>>> We will think how to lessen the amount and granularity of this. 

note that this last line was _not_ quoted in my mail.

>>> Christoph Hellwig wrote:
>>>> It's everything but convenient :)  Please make it one config option to
>>>> compile in all debug code and then have a module option to select the
>>>> verbosity level at runtime.
>>> Surely that judgement should be made by people who actually debug UBIFS.

> You have gone off on a tangent.  The original context was discussing the
> need for granulated debug messages.  I have restored the context above.

I think you haven't read my statement at all.  Please look at the quoted
bit above.  There is nothing against having different
vebosity/granularity levels, quite to the contrary.  I just told you
that a run-time selection of them is everything but convenient and they
should rather be at runtime. 

> You seem to have mistakenly inferred I was impugning your judgement.  That
> was not the point.

No, the point was that you didn't read my message and/or assumes just
because I'm not 100% on your line of reasoning I'm against you.

> Coming back to your issue of a mount-time option for debug messages.  I am
> not sure any other file systems do that.  In general I would say having to
> switch on the debug config option and also change either the kernel command
> line or init scripts, seems in fact much less convenient.

It means you can be debug different bits without recompiling which is a
very good thing.  Especially if you're debugging moves from one area to
another.
