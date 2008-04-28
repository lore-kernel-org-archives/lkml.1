Return-Path: <linux-kernel-owner+w=401wt.eu-S1763306AbYD1Duj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763306AbYD1Duj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbYD1Dua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:50:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760714AbYD1Du3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:50:29 -0400
Date: Sun, 27 Apr 2008 23:50:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080428035023.GA14275@infradead.org>
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427232317.GB103491721@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:23:17AM +1000, David Chinner wrote:
> No. That code is complex enough with only one copy of it around. I don't
> want two copies that differ subtly and hence have two different sets
> of nasty, rarely hit corner cases in them.

Actually the split makes some sense.  I had a ready patch to split out
releasepage which makes the whole code a lot nicer.  I didn't go forward
with it because I had this idea that it would get replaced by Chris
extent_map stuff ASAP..

