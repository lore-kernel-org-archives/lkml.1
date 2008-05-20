Return-Path: <linux-kernel-owner+w=401wt.eu-S1764657AbYETR1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764657AbYETR1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYETR1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:27:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbYETR1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:27:42 -0400
Date: Tue, 20 May 2008 13:27:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, systemtap@sources.redhat.com
Subject: Re: [2.6 patch] unexport uts_sem
Message-ID: <20080520172730.GA2361@infradead.org>
References: <20080505182937.GZ17139@cs181133002.pp.htv.fi> <y0mwsloq4kc.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mwsloq4kc.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 01:16:19PM -0400, Frank Ch. Eigler wrote:
> Am I correct that this would makes it invalid for modules to call
> utsname() (since the protective semaphore is now hidden)?

Yesm they should never had done that anyway.  The module support
does it's own version checking already.

