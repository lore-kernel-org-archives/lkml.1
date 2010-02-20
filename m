Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0BTUoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 15:44:39 -0500
Received: from relay4-v.mail.gandi.net ([217.70.178.78]:44251 "EHLO
	relay4-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0BTUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 15:44:38 -0500
Date: Sat, 20 Feb 2010 12:44:19 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/18] sysctl extern cleanup - rcu
Message-ID: <20100220204418.GB3997@feather>
References: <20100220141620.GI3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100220141620.GI3195@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 10:16:20PM +0800, Dave Young wrote:
> Extern declarations in sysctl.c should be move to their own head file,
> and then include them in relavant .c files.
> 
> Move rcutorture_runnable extern declaration to linux/rcupdate.h
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Acked-by: Josh Triplett <josh@joshtriplett.org>

That said, this could probably become something other than a sysctl
easily enough; debugfs or writable module parameters come to mind.

- Josh Triplett
