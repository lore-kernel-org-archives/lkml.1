Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbYBSSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbYBSSu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYBSSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:50:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbYBSSuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:50:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
In-Reply-To: Shi Weihua's message of  Tuesday, 19 February 2008 08:58:02 +0800 <47BA299A.3040207@cn.fujitsu.com>
References: <47B95C4D.6080000@cn.fujitsu.com>
	<20080218134720.GA28851@elte.hu>
	<47BA299A.3040207@cn.fujitsu.com>
X-Shopping-List: (1) Anonymous yies
   (2) Odious burrowing imports
   (3) Humorous expectorants
   (4) Hierarchical obedient auctions
Message-Id: <20080219185009.122ED2701BA@magilla.localdomain>
Date: Tue, 19 Feb 2008 10:50:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change looks bogus to me.  Before I get to the content, there is a nit
that annoys me.  You changed the punctuation in my comment so that it no
longer means what it did, and now the comment is nonsensical.  I don't
demand decent English from hackers of any linguistic bent, but please don't
louse up the coherent sentences I wrote when moving them down ten lines.

Please elaborate on the rationale that justifies this change.
I don't see it at all.

If you are already on the signal stack, it doesn't matter whether the
signal that just arrived has SA_ONSTACK set or not.  If you are going to
overflow the stack with the new signal frame, we want to prevent that
clobberation regardless.


Thanks,
Roland
