Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbXK0XI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbXK0XI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759971AbXK0XIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:08:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759894AbXK0XID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:08:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [PATCH 1/3] signal(i386): alternative signal stack
	wraparound occurs
In-Reply-To: Ingo Molnar's message of  Tuesday, 27 November 2007 11:50:45 +0100 <20071127105045.GG6286@elte.hu>
References: <20071126143317.dd884128.akpm@linux-foundation.org>
	<20071126230242.GA9623@elte.hu>
	<20071127030222.ACD7326F8C5@magilla.localdomain>
	<20071127105045.GG6286@elte.hu>
Emacs: more boundary conditions than the Middle East.
Message-Id: <20071127230758.8099526F8E7@magilla.localdomain>
Date: Tue, 27 Nov 2007 15:07:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks Roland for the detailed analysis. I've queued up the patch below 
> in the x86 tree. I suspect we can wait with this for v2.6.25, due to 
> this being long-standing behavior of Linux? Thus we could observe the 
> effects of this patch for a longer time.

It's certainly nothing new.  The failure mode of concern is only for a
buggy program to fail to crash as quickly and gracefully as it might.


Thanks,
Roland
