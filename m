Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZDWIuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZDWIuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbZDWIub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:50:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45635 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbZDWIua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:50:30 -0400
Date: Thu, 23 Apr 2009 10:54:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] proc: export more page flags in /proc/kpageflags (take 3)
Message-ID: <20090423085405.GL13896@one.firstfloor.org>
References: <20090414071159.GV14687@one.firstfloor.org> <20090415131800.GA11191@localhost> <20090416111108.AC55.A69D9226@jp.fujitsu.com> <20090423022625.GA8822@localhost> <20090423074848.GJ13896@one.firstfloor.org> <20090423081047.GA18898@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423081047.GA18898@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good idea.
> 
> Would you recommend a good way to identify huge pages?
> Test by page order, or by (dtor == free_huge_page)?      

That doesn't work for GB pages. The best way would be to make
slub stop using it and then check for compound, but I don't know what 
this implies. Otherwise would need some other way, perhaps a new
flag?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
