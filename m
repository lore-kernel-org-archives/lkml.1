Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbXJ3Ltz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbXJ3Ltz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXJ3Lts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:49:48 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44802 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751262AbXJ3Ltr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:49:47 -0400
Message-ID: <393744987.14537@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 30 Oct 2007 19:49:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
References: <20071028152428.GJ7918@iucha.net> <E1ImlvH-0003YH-Qf@localhost> <20071030114250.GL25561@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030114250.GL25561@iucha.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1ImpbK-0000l3-1u@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 06:42:50AM -0500, Florin Iucha wrote:
> On Tue, Oct 30, 2007 at 03:54:03PM +0800, Fengguang Wu wrote:
> > It could be triggered by the more aggressive writeback behavior - the
> > new code will keep on retrying as long as there are dirty inodes pending.
> > 
> > Florin, would you try the attached patches against 2.6.24-git?
> > They may generate big traffic of printk messages, but will help
> > debug the problem.
> 
> I have updated to v2.6.24-rc1-334-g82798a1.  After using my computer
> for two hours, I left the computer idle overnight.  This morning,
> pdflushd is again consuming 25% of a CPU.  I will try Fengguang's
> patches today.

Thank you.

Be sure to stop klogd ;-)
A `dmesg` will be sufficient for debugging.

btw, I cannot reproduce it with simple NFSv3 tests.

Fengguang

