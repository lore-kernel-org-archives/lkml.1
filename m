Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbXGMIM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbXGMIM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbXGMIMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:12:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbXGMIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:12:18 -0400
Subject: Re: [RFT][PATCH] mm: drop behind
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Snook <csnook@redhat.com>
Cc: Tim Pepper <lnxninja@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <46967EE2.8020803@redhat.com>
References: <1184007008.1913.45.camel@twins>
	 <eada2a070707111537p20ab429anebd8b1840f5e5b5f@mail.gmail.com>
	 <1184225086.20032.45.camel@twins>  <46967EE2.8020803@redhat.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 10:12:09 +0200
Message-Id: <1184314329.20032.70.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 15:20 -0400, Chris Snook wrote:

> Then do what we do for FADV_SEQUENTIAL.  With that advice, we double the 
> readahead window.  We're already doing readahead, but we do a lot more 
> when we have the advice.  NOREUSE should put much greater pressure on 
> the vm to drop these pages quickly, or perhaps simply eliminate the 
> heuristic evaluation of the access pattern and short-circuit straight to 
> dropping the pages.
> 
> We should be encouraging application writers to actually use things like 
> fadvise when they can tune things more intelligently than kernel 
> heuristics can.

I like this, I'll see what I can do.. :-)

