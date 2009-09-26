Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZIZL6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZIZL6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 07:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZIZL6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 07:58:54 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:35935 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbZIZL6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 07:58:53 -0400
X-Trace: 262877299/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.103.91/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.103.91
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAKeevUpPRWdb/2dsb2JhbACBUNQZhB4F
X-IronPort-AV: E=Sophos;i="4.44,456,1249254000"; 
   d="scan'208";a="262877299"
Date: Sat, 26 Sep 2009 12:58:53 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
In-Reply-To: <20090926114806.GA12419@localhost>
Message-ID: <Pine.LNX.4.64.0909261251090.15781@sister.anvils>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils>
 <20090926114806.GA12419@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009, Wu Fengguang wrote:
> 
> However we may well end up to accept the fact that "we just cannot do
> hwpoison 100% correct", and settle with a simple and 99% correct code.

I thought we already accepted that: you cannot do hwpoison 100% correct
(or not without a radical rewrite of the OS); you're just looking to
get it right almost all the time on those systems which have almost
all their pages in pagecache or userspace or free.

Hugh
