Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZBNGMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZBNGMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 01:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZBNGMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 01:12:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34042
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbZBNGMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 01:12:31 -0500
Date: Fri, 13 Feb 2009 22:12:26 -0800 (PST)
Message-Id: <20090213.221226.264144345.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       davem@davemlloft.net, heiko.carstens@de.ibm.com, stable@kernel.org
Subject: Re: [PATCH 1/2] clean up for early_pfn_to_nid
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090213142032.09b4a4da.akpm@linux-foundation.org>
References: <20090212161920.deedea35.kamezawa.hiroyu@jp.fujitsu.com>
	<20090212162203.db3f07cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090213142032.09b4a4da.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 13 Feb 2009 14:20:32 -0800

> I queued these as
> 
> mm-clean-up-for-early_pfn_to_nid.patch
> mm-fix-memmap-init-for-handling-memory-hole.patch
> 
> and tagged them as needed-in-2.6.28.x.  I don't recall whether they are
> needed in earlier -stable releases?

Every kernel going back to at least 2.6.24 has this bug.  It's likely
been around even longer, I didn't bother checking.
