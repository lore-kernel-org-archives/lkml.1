Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYKQRPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYKQRPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYKQRPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:15:11 -0500
Received: from broadrack.ru ([195.178.208.66]:41498 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbYKQRPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:15:10 -0500
Date: Mon, 17 Nov 2008 20:15:08 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: mtk.manpages@gmail.com
Cc: Robert Love <rlove@rlove.org>, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081117171508.GA564@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.

On Mon, Nov 17, 2008 at 11:59:11AM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
> NAK.  If we are going to do this -- and I leave the security
> discussions to others more knowlegeable on that score than me -- then
> the API design should be better than this.  The current design is a
> hack.  Why exclude rename events?  Why re-use the cookie field?  The
> only answers I can guess at are that the current patch is less work to
> write.  IMO, there are (much) better design possibilities, using
> inotify1(), as I suggested earlier in this thread.

Cookie was created to store information used to somehow connect events to
each other. PID does that from another angle than rename. Extending
(rewriting userspace event processing part) events is a solution for the
new project, while existing patch (where all security concerns are
resolved) is a minimum functionality extension.

if I will spent a day and rewrite userspace report side to report new
events I'm pretty sure there will be people, who will start complaining
that again design does not match some theoretically perfect
expectations, and for the purpose of reporting origin's PID cookie
fields can be reused since right now it is unused.

Plus, if it is that hard to comment on patch which adds 14 (!) lines
including blank, which feedback we should expect on larger one? :)

-- 
	Evgeniy Polyakov
