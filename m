Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXDICGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXDICGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 22:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXDICGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 22:06:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXDICGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 22:06:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
In-Reply-To: Eric W. Biederman's message of  Sunday, 8 April 2007 19:05:29 -0600 <m1d52e2w86.fsf@ebiederm.dsl.xmission.com>
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Message-Id: <20070409020600.6338BD82F4@pipsqueak.sf.frob.com>
Date: Sun,  8 Apr 2007 19:06:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I concur with Eric's assessment.  Adding new magic bits to the generic
clone path seems like a poor way to cope with kernel threads.  I think
it's better if kernel thread setup gets less like normal user process
setup.  I also agree with Eric that PPID of 0 is a very natural way for
kernel threads to be displayed.  We need to know more about the nature
of the compatibility issue in procps to judge whether there is good
reason to avoid changing it.


Thanks,
Roland
