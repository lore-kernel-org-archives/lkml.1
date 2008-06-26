Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYFZLcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYFZLcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZLcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:32:15 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:50025 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbYFZLcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:32:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEGANexXkh5LG+uZWdsb2JhbACSahICHpsi
X-IronPort-AV: E=Sophos;i="4.27,708,1204464600"; 
   d="scan'208";a="143496978"
Date: Thu, 26 Jun 2008 21:32:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626113209.GK11558@disturbed>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626112612.GW4392@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626112612.GW4392@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 05:26:12AM -0600, Matthew Wilcox wrote:
> On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> > XFS object flushing doesn't quite match existing completion semantics.  It
> > mixed exclusive access with completion. That is, we need to mark an object as
> > being flushed before flushing it to disk, and then block any other attempt to
> > flush it until the completion occurs.
> 
> This sounds like mutex semantics.  Why are the existing mutexes not
> appropriate for your needs?

Different threads doing wait and complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
