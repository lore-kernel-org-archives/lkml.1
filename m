Return-Path: <linux-kernel-owner+w=401wt.eu-S1763779AbZEHTGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763779AbZEHTGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZEHTGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:06:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47593 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZEHTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:06:07 -0400
Date: Fri, 8 May 2009 21:11:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 MCE: shut up lockdep warning
Message-ID: <20090508191101.GB23223@one.firstfloor.org>
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com> <1241771697.11251.194.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241771697.11251.194.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So was this a genuine bug in your code? The patch suggests it was.

No I think it was false. See my earlier email.

The higher level cpu_add_remove_lock makes sure that there is never
an interrupt when the code is running process context.

So Ingo's patch shuts off lockdep, but it's overkill and not really
needed. It would be better if there was some way to express
the dependency on cpu_add_remove_lock, but I'm not sure
that can be expressed in lockdep.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
