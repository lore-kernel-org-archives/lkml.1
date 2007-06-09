Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXFITAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXFITAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbXFITA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:00:26 -0400
Received: from waste.org ([66.93.16.53]:32797 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155AbXFITA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:00:26 -0400
Date: Sat, 9 Jun 2007 14:00:10 -0500
From: Matt Mackall <mpm@selenic.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.13
Message-ID: <20070609190010.GA11166@waste.org>
References: <20070608070028.GA3457@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608070028.GA3457@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:00:28AM -0700, Chris Wright wrote:
> We (the -stable team) are announcing the release of the 2.6.20.13 kernel.
> This release has three security fixes in it:
>  
> 54bb290b: random: fix error in entropy extraction (CVE-2007-2453 1 of 2)
> f5939fcd: random: fix seeding with zero entropy (CVE-2007-2453 2 of 2)
> 
> The /dev/[u]random fix is especially important for machines with no
> entropy source (e.g. keyboard, mice, or disk drives) and no realtime clock
> since successive boots could generate same output from RNG.

For the record, /dev/random was not impacted. It will fail safe (eg
block forever) on machines with no entropy sources.

-- 
Mathematics is the supreme nostalgia of our time.
