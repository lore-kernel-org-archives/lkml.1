Return-Path: <linux-kernel-owner+w=401wt.eu-S937951AbXHLTUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937951AbXHLTUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934581AbXHLTUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:20:37 -0400
Received: from smtpserver.visit.se ([85.194.0.110]:52892 "EHLO mail.visit.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933285AbXHLTUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:20:36 -0400
In-Reply-To: <20070812195525.20dbb6fc@the-village.bc.nu>
References: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org> <20070812161337.3828381c@the-village.bc.nu> <A94120FD-315A-45B7-A8F4-8DC8DC21279E@nocrew.org> <20070812195525.20dbb6fc@the-village.bc.nu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B37532D9-870C-4412-8ADF-83E20F75E18A@nocrew.org>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Fredrik Noring <noring@nocrew.org>
Subject: Re: Improving read/write/close system call reliability when used with pthreads
Date: Sun, 12 Aug 2007 21:19:39 +0200
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Alan Cox wrote:
> Given that 99.99% of programs don't appear to care and you materially
> slow down a critical path for every read and write I'm skeptical.

I've made required_fds a struct list_head list to accommodate for  
multiple fd:s (not sure that's absolutely needed though), so a couple  
of pointers need to be updated in sys_read/write. However, if that's  
too slow, and we only care about bookkeeping a single fd which is the  
case with sys_read/write, that can be changed into a single fd  
integer assignment.

Would that be fast enough?

Fredrik

