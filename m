Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYD1FLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYD1FLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYD1FLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:11:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48971 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898AbYD1FLF (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:11:05 -0400
Date: Mon, 28 Apr 2008 15:10:40 +1000
From: David Chinner <dgc@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080428051040.GH103491721@sgi.com>
References: <20080425170021.GH14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425170021.GH14990@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 11:00:21AM -0600, Matthew Wilcox wrote:
> 
> It's been a Good Idea for a while to use mutexes instead of
> semaphores where possible.  Additional debuggability, better optimised,
> better-enforced semantics, etc.
> 
> Obviously, there are some places that can't be converted to mutexes.
> I'm not proposing blind changes. 

Matthew, what's the plan for code using semaphores that cannot be
easily converted to something else? e.g. XFS?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
