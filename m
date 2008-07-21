Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYGUITk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYGUITk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYGUITd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:19:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbYGUITc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:19:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/23] /proc/PID/syscall
In-Reply-To: Alexey Dobriyan's message of  Friday, 18 July 2008 02:56:32 +0400 <20080717225632.GA16887@martell.zuzino.mipt.ru>
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080717073144.5A28715411D@magilla.localdomain>
	<20080717225632.GA16887@martell.zuzino.mipt.ru>
X-Zippy-Says: I'm ZIPPY the PINHEAD and I'm totally committed to the festive mode.
Message-Id: <20080721081925.B666515421D@magilla.localdomain>
Date: Mon, 21 Jul 2008 01:19:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My gut feeling this code needs ptrace_may_access() checks.

That would be fine with me.  The nodes are readable only by user, which
seems sufficient to me.  But I certainly don't object to the stronger check
there.  I didn't put too much thought into /proc/pid/syscall, it's just
there to demonstrate and test the internal task_current_syscall() call.


Thanks,
Roland
