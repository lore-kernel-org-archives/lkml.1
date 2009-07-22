Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZGVWEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZGVWEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZGVWEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:04:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbZGVWEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:04:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC 1/2] move binfmt filed to signal_struct
In-Reply-To: Andrew Morton's message of  Wednesday, 22 July 2009 13:23:02 -0700 <20090722132302.a9889eb3.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <4A56FEF7.80207@ct.jp.nec.com>
	<20090722132302.a9889eb3.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090722220353.88B2A67B6E@magilla.sf.frob.com>
Date: Wed, 22 Jul 2009 15:03:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Because the binfmt is not different between threads in the same process,
> > it can be moved from task_struct to signal_struct.
> 
> Seems like a logical cleanup to me.

IMHO binfmt belongs in mm_struct.

> We should rename signal_struct.

Indeed, it's in fact 'struct process'.  But historically Linus has objected
to admitting that there is really a concept of process in the POSIX sense
that exists deep in the implementation (as it truly does for years now),
beyond "tasks that happen to share a lot of CLONE_* stuff".  The name
signal_struct is sufficiently misleading to make it easier to retain the
fantasy he prefers. ;-)


Thanks,
Roland
