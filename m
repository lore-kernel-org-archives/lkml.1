Return-Path: <linux-kernel-owner+w=401wt.eu-S1764308AbXHCWGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764308AbXHCWGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761886AbXHCWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:06:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762642AbXHCWGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:06:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill an obsolete sub-thread-ptrace stuff
In-Reply-To: Oleg Nesterov's message of  Saturday, 4 August 2007 02:00:48 +0400 <20070803220048.GA277@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070803220600.8EDEF4D04BC@magilla.localdomain>
Date: Fri,  3 Aug 2007 15:06:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> However, I disagree. exit_notify() doesn't check the ptrace-same-group
> case. So, unless I missed something, we set EXIT_DEAD in any case, even
> if ptracer doesn't belong to our thread group.

Oh, you're right.  I was reading the other line you changed.


Thanks,
Roland
