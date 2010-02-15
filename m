Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0BOUd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:33:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab0BOUdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:33:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracehook: add some self tests
In-Reply-To: Mike Frysinger's message of  Monday, 15 February 2010 15:28:29 -0500 <8bd0f97a1002151228r2a589047gddc1d998d52c969c@mail.gmail.com>
References: <1266214553-29476-1-git-send-email-vapier@gentoo.org>
	<20100215193948.GA28419@redhat.com>
	<8bd0f97a1002151228r2a589047gddc1d998d52c969c@mail.gmail.com>
X-Windows: flawed beyond belief.
Message-Id: <20100215203323.989DB1AD@magilla.sf.frob.com>
Date: Mon, 15 Feb 2010 12:33:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> is there some task available while the kernel is initializing ?  i.e.
> the test is compiled in ?
> 
> if current is valid, i'll just [ab]use that ...

I don't think you can win with any kind of abuse on ia64.  (For other
machines that only test the compat state of the task, any task will
do--though perhaps only test half the code.)  AFAICT, on ia64 only a real
empirical test can work at all.  That is, you must really be referring to a
task and its task_pt_regs() when that task really has entered the kernel
for a syscall.


Thanks,
Roland
