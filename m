Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbZLJNl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbZLJNl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760667AbZLJNl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:41:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658AbZLJNl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:41:58 -0500
Date: Thu, 10 Dec 2009 14:42:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [19/31] mm: export stable page flags
Message-ID: <20091210134200.GP18989@one.firstfloor.org>
References: <200912081016.198135742@firstfloor.org> <20091208211635.7965AB151F@basil.firstfloor.org> <1260311251.31323.129.camel@calx> <20091209020042.GA7751@localhost> <20091210015014.GK18989@one.firstfloor.org> <20091210020927.GA11017@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210020927.GA11017@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Your original patch didn't handle hwpoison as module btw.
> 
> Yes I realized it later..

It's always a big trap, I've seen lots of people (including myself)
run into it.

I preferred to not have the ifdefs in the core module, simply
because it's very little additional code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
