Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZLAEOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZLAEOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZLAEOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:14:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56323 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbZLAEOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:14:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911301227530.24660@sister.anvils>
References: <20091130180452.5BF6.A69D9226@jp.fujitsu.com> <Pine.LNX.4.64.0911301227530.24660@sister.anvils>
Message-Id: <20091201125801.5C16.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Dec 2009 13:14:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > btw, I'm not sure why bellow kmem_cache_zalloc() is necessary. Why can't we
> > use stack?
> 
> Well, I didn't use stack: partly because I'm so ashamed of the pseudo-vmas
> on the stack in mm/shmem.c, which have put shmem_getpage() into reports
> of high stack users (I've unfinished patches to deal with that); and
> partly because page_referenced_ksm() and try_to_unmap_ksm() are on
> the page reclaim path, maybe way down deep on a very deep stack.
> 
> But it's not something you or I should be worrying about: as the comment
> says, this is just a temporary hack, to present a patch which gets KSM
> swapping working in an understandable way, while leaving some corrections
> and refinements to subsequent patches.  This pseudo-vma is removed in the
> very next patch.

I see. thanks for kindly explanation :)



