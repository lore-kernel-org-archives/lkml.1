Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXJQESk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXJQESk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 00:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXJQESG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 00:18:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53335 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbXJQER5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 00:17:57 -0400
Date: Wed, 17 Oct 2007 09:47:52 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 0/4] Refcount Based Cpu-Hotplug Revisit.
Message-ID: <20071017041752.GA9940@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <alpine.LFD.0.999.0710161015510.6887@woody.linux-foundation.org> <20071017021112.GA15895@in.ibm.com> <alpine.LFD.0.999.0710161922430.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710161922430.26902@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 07:23:38PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Dipankar Sarma wrote:
> > 
> > Unless I am reading the patch wrongly, it seems cpu_hotplug_begin() is called 
> > while holding the cpu_add_remove_lock mutex. So, another CPU cannot come in
> > and do the same until _cpu_down() is over.
> 
> Ahh, in that case I take back that objection, although maybe a comment 
> about the required nesting within the other mutex is in order? Or maybe 
> it's there and I just missed it (blush).

Good point! I'll add the comment before cpu_hotplug_begin().


> 
> 			Linus

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
