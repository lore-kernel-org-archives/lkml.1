Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbXIJJIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbXIJJIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbXIJJIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:08:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47057 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXIJJIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:08:15 -0400
Date: Mon, 10 Sep 2007 10:08:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910090808.GA31204@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Adrian Bunk <bunk@kernel.org>, perex@suse.cz,
	linux-kernel@vger.kernel.org
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909145940.0b41c8a5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 02:59:40PM -0700, Andrew Morton wrote:
> Sure.  But I think it is better to give people some warning when we're
> planning on breaking out-of-tree things.  I do occasionally receive reports
> of "hey, the X driver which I get from Y doesn't work any more".  Often
> it's open-source stuff, too.  I see no point in irritating our users more than
> we need to.

There is no fucking reason they should have used it in the first place.
Until we have something like a coherent export API instead of random crap
exported because someone once needed it to do a dumb thing it'll happen.
Only way to avoid it is to merge the driver and shake out their dumb ideas
in the review process.

> Adrian knows this, yet he habitually sends zero-warning export-removal
> patches and I habitually ignore them.  I guess we must both enjoy this or
> something.

And I think almost everyone disagrees with you.  We just carry too much
crap around because of your subborness in this issue, and it gets really
annoying to have some high up on the food chain fighting his longly flight
against the other people.
