Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYELNBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYELNBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYELNBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:01:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYELNBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:01:03 -0400
Date: Mon, 12 May 2008 09:00:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dwmw2@infradead.org, Vivi Li <vivi.li@analog.com>
Subject: Re: [PATCH 4/4] [MM/NOMMU]: Export two symbols in nommu.c for mmap
	test
Message-ID: <20080512130058.GA8981@infradead.org>
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org> <1210588325-11027-5-git-send-email-cooloney@kernel.org> <8bd0f97a0805120338l1d7e0e7eiffebae3bf33c172c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0805120338l1d7e0e7eiffebae3bf33c172c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 06:38:55AM -0400, Mike Frysinger wrote:
> On Mon, May 12, 2008 at 6:32 AM, Bryan Wu <cooloney@kernel.org> wrote:
> > From: Vivi Li <vivi.li@analog.com>
> >
> > http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=2312
> 
> i dont think URLs to our tracker is a good substitute for log
> messages.  our tracker URLs have known to break in the past (due to
> gforge changes), and it's a pain for people reading changelogs to open
> up a browser just to see what the issue is about.

Yeah, even the url pointer to there is totally unreadable.  I still
don't understand why you want to export this symbols.  Also please make
sure to always submit the code actually using the exports in the same
patchkit, that makes it a lot easier to figure.
