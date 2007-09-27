Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbXI0MDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbXI0MDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbXI0MD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:03:26 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2789 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXI0MDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:03:25 -0400
Date: Thu, 27 Sep 2007 13:03:08 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm1 -- powerpc link failure
Message-ID: <20070927120308.GJ2213@shadowen.org>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org> <20070925134653.GB8447@shadowen.org> <Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> actually, my first patch wasn't using weak symbols, but I have been 
> convinced that it's the way to go(tm). Please see 
> http://lkml.org/lkml/2007/9/1/131 and the ongoing thread.
> 
> I am fine with replacing the brk randomization patch with the one that 
> wasn't using weak symbols (posted in the mentioned thread too), I have no 
> strong opinion either way.

Ok, this problem seems to still persist in 2.6.23-rc8-mm2.  It seems
we have three options from here:

1) update the compiler support list to exclude these compilers, or
2) back this change out, or
3) switch to the version not using __weak.

The latter seems to be the least intrusive change.  As no-one closer
to the problem is stepping up to make the decision I will propose
we go with the third option here.

-apw
