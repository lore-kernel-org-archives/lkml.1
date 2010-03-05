Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0CEOSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:18:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:49523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0CEOS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:18:29 -0500
Message-ID: <4B91128A.5000305@kernel.org>
Date: Fri, 05 Mar 2010 23:17:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] improve stop_machine performance
References: <20100304212034.GA3171@sgi.com> <4B904EA8.3050709@kernel.org> <20100305141143.GA17417@sgi.com>
In-Reply-To: <20100305141143.GA17417@sgi.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Mar 2010 14:17:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/05/2010 11:11 PM, Dimitri Sivanich wrote:
> It seems reasonable as long as setup is fast enough.  Will that
> thread indeed become fully uninterruptible (not affected by anything
> including scheduler decisions like
> sched_rt_period_us/sched_rt_runtime_us, etc..)?

I think so.  They basically are used to do the same thing - occupying
the CPU.  I'll give a shot.  Please give me a couple of days.

Thanks.

-- 
tejun
