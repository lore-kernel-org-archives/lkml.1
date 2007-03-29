Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXC2L7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXC2L7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXC2L7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:59:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:38205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbXC2L67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:58:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Add support for deferrable timers (respun-Mar28)
Date: Thu, 29 Mar 2007 13:58:52 +0200
User-Agent: KMail/1.9.5
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk,
       johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <200703291341.13172.ak@suse.de> <7B0DEC32-4413-46CB-BB4D-DC6A1674F2EC@mac.com>
In-Reply-To: <7B0DEC32-4413-46CB-BB4D-DC6A1674F2EC@mac.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703291358.53202.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Might also be useful to add an extra option to "top" to reduce the  
> polling frequency if the system is otherwise idle.  A fixed 30-sec  
> timer and a deferrable 1-sec timer or somesuch?

Hmm, i think the current implementation is per CPU. top really would
like to have one that applies to all CPUs though.

Thinking about it for sane user space semantics it would probably need
a global implementation anyways.

Perhaps it could use the same infrastructure as RCU does to handle this?

-Andi
