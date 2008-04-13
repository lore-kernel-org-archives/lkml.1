Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYDMIBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYDMIBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYDMIBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:01:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYDMIBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:01:36 -0400
Date: Sun, 13 Apr 2008 04:01:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080413080130.GA9622@infradead.org>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 08:55:44PM -0700, Andrew Morton wrote:
> > it's a dead filesystem that a very few people still have a reason to
> > use.  If FUSE is where this should live, then I'll just simply focus my
> > time on that instead (since I already have it in FUSE).
> 
> Yes, pursuing the FUSE implementation sounds a better approach - it avoids
> burdening the kernel with a filesysstem which few will be interested in and
> is more practical for use by those who _are_ interested in it.

No way.  For a normal foreign block filesystem a proper kernel
implementation is much better.  And this one is particularly
well-written.  Lately I really start wondering why we keep adding crap
all over the core, but if we have a modular new filesystem that's quite
nice people start complaining.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
