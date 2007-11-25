Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbXKYWh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbXKYWh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbXKYWhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:37:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXKYWhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:37:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 10/27] ptrace: generic resume
In-Reply-To: Christoph Hellwig's message of  Sunday, 25 November 2007 22:23:52 +0000 <20071125222352.GB1597@infradead.org>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
	<20071125220109.10BC726F8C5@magilla.localdomain>
	<20071125222352.GB1597@infradead.org>
X-Shopping-List: (1) Lascivious squirrels
   (2) Proficient warriors
   (3) Nostalgic perplexers
   (4) Injured floats
Message-Id: <20071125223741.7236526F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:37:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Could we by any chance just force every architecture using generic code
> to implement PTRACE_SINGLESTEP and PTRACE_SYSEMU?  This will lead to
> both far less messy code and a more consistant user interface.

I'd like to look into that later after most arch's have moved to using the
generic code for their existing support.  I am thoroughly in favor, but it
requires some more groundwork that can come after this initial stage.


Thanks,
Roland
