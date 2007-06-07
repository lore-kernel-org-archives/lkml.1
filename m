Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbXFGGMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbXFGGMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbXFGGMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:12:05 -0400
Received: from holomorphy.com ([66.93.40.71]:59486 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXFGGME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:12:04 -0400
Date: Wed, 6 Jun 2007 23:13:03 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607061303.GP6909@holomorphy.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606163053.GM6909@holomorphy.com> <20070606111315.884cf712.akpm@linux-foundation.org> <20070606194329.GO6909@holomorphy.com> <6599ad830706061732i1ecb70f3gf0f4c288ba74563d@mail.gmail.com> <20070606180924.e455b13c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606180924.e455b13c.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 06:09:24PM -0700, Andrew Morton wrote:
> ooh, yes, lockdep_init() really does want to be called before anything
> else.
> So do we take it that this code hasn't been tested with lockdep?  Please
> don't forget that step - lockdep finds some pretty nasty bugs sometimes.
> This?

I found this patch when I woke and it got things booting with the full
-mm stack. Now to fix the sparc32 build and see if it boots.


-- wli
