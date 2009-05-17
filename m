Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZEQTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZEQTOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZEQTOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:14:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbZEQTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:14:31 -0400
Date: Sun, 17 May 2009 12:13:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [Bug #13107] LTP 20080131 causes defunct processes
 w/2.6.30-rc1
In-Reply-To: <385Pu-agh7M.A.K7C._ZzDKB@chimera>
Message-ID: <alpine.LFD.2.01.0905171206330.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.K7C._ZzDKB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Rafael J. Wysocki wrote:
>
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
> Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
> Submitter	: Kumar Gala <galak@kernel.crashing.org>
> Date		: 2009-04-09 15:43 (38 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
> References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
> 		  http://lkml.org/lkml/2009/4/10/193
> Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

I think we have to revert that thing. I haven't heard of any fixes to that 
commit.

		Linus
