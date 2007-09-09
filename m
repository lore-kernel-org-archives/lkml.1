Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXIIUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXIIUmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbXIIUl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:41:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52660 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbXIIUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:41:58 -0400
Date: Sun, 9 Sep 2007 21:41:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [-mm patch] unexport raise_softirq_irqoff
Message-ID: <20070909204153.GB11764@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202544.GV3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909202544.GV3563@stusta.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 10:25:44PM +0200, Adrian Bunk wrote:
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc3-mm1:
> >...
> >  git-net.patch
> >...
> >  git trees
> >...
> 
> raise_softirq_irqoff no longer has any modular user.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

This should probably go in through Dave's tree as it's removing this
rather annoying user.

