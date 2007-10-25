Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXJYS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXJYS2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXJYS2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:28:31 -0400
Received: from tim.rpsys.net ([194.106.48.114]:56726 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXJYS2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:28:30 -0400
Subject: Re: Linux machines dieing in swap storms
From: Richard Purdie <rpurdie@rpsys.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071025171311.42844d17@the-village.bc.nu>
References: <1193325641.5776.21.camel@localhost.localdomain>
	 <20071025171311.42844d17@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 19:28:20 +0100
Message-Id: <1193336900.5697.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 17:13 +0100, Alan Cox wrote:
> > I'm seriously tempted to add a "kill the process using the most memory"
> > key combination into SysRq which might let me save the desktop but won't
> > help with my remote server. I could also just disable swap I guess.
> 
> For specific applications you can set resource limits, you can also set
> OOM priorities in current kernels to pick who dies.

I couldn't seem to find much documentation on this. For the archive and
to confirm we're talking about the same thing, you mean:

echo 10 > /proc/PID/oom_adj

(and ulimit/setrlimit for the resource limits) ?

This assumes I know in advance which processes are likely to go mad
which isn't ideal although it could solve my immediate problem.

> Finally you can disable overcommit and go for a rigid "no overcommit"
> policy where the system will fail any memory allocation which might lead
> to out of memory situations later.

Its certainly another option but other processes then suffer because
certain applications have bugs in them?

Thanks,

Richard

