Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbYGQHiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbYGQHiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbYGQHeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:34:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760637AbYGQHee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:34:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ptrace children revamp
In-Reply-To: Andrew Morton's message of  Thursday, 17 July 2008 00:30:50 -0700 <20080717003050.87f96ab0.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080717071141.012BD15411D@magilla.localdomain>
	<20080717071322.B80F315411D@magilla.localdomain>
	<20080717003050.87f96ab0.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080717073430.38C9315411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:34:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, copying this code didn't do much to improve the world.
> 
> Is there any prospect of "fixing" this somehow?

Yes.  After this settles, it will become tractable to change the whole
locking plan for ptrace so we don't have this problem and get rid of this
kludge altogether.


Thanks,
Roland
