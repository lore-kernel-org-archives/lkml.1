Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYFZNSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYFZNSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYFZNSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:18:33 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:50862 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYFZNSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:18:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIDANQtY0h5LG+uZWdsb2JhbACSYRICHp9e
X-IronPort-AV: E=Sophos;i="4.27,708,1204464600"; 
   d="scan'208";a="135867909"
Date: Thu, 26 Jun 2008 23:18:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626131829.GT29319@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	matthew@wil.cx, linux-kernel@vger.kernel.org
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626074636.GB7064@infradead.org> <20080626112133.GJ11558@disturbed> <20080626130700.GA24325@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626130700.GA24325@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 09:07:00AM -0400, Christoph Hellwig wrote:
> On Thu, Jun 26, 2008 at 09:21:33PM +1000, Dave Chinner wrote:
> > Ok, so that involves exactly what? A new header file, a new API name
> > (ideas anyone?) and kerneldoc comments?
> 
> Yes, probably just a new header with properly documented functions.
> Thew two non-trivial ones you added should probably not be inlines,
> btw.

Yeah, they grew a little bigger than expected...

> flush_lock_init/flush_lock/flush_trylock/flush_done/flush_is_locked?

Ok, I was thinking along those lines. I'll redo the patch series
using that interface tomorrow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
