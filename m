Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZAIXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZAIXpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZAIXpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:45:36 -0500
Received: from ozlabs.org ([203.10.76.45]:37581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZAIXpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:45:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.57319.639438.433546@cargo.ozlabs.ibm.com>
Date: Sat, 10 Jan 2009 10:38:15 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] Performance counters for POWER
In-Reply-To: <20090109134727.GA902@elte.hu>
References: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
	<20090109134727.GA902@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Do timec.c and kerneltop.c work fine for you by any chance? If yes, could 
> you send us some sample output that you get with them on your power 
> testbox(es)?

timec.c works with some minor modifications.  I'll post my version in
a separate message.  The main difference is that syscall() on powerpc
returns -1 on error and sets errno, rather than returning a negative
error number.  I also added a way to specify raw events.

I haven't looked in detail at kerneltop.c yet.  I have done a small
test program that exercises interrupt counters though.

> Also, would this be the right moment for me to pull from you?

Actually, I have discovered some bugs, so I'll need to do new versions
of 7/9 and 8/9.  I'll let you know when I have redone the git tree.

Paul.
