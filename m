Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXIZKJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXIZKJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXIZKJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:09:14 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1327 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbXIZKJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:09:14 -0400
Date: Wed, 26 Sep 2007 12:08:59 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926100859.GJ3337@deprecation.cyrius.com>
References: <20070926085202.GE3337@deprecation.cyrius.com> <20070926093445.GA24768@elte.hu> <20070926094726.GA27006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926094726.GA27006@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2007-09-26 11:47]:
> > this will gather a good deal of info about the workload in question. 
> > Please send me the resulting debug file.
> Another thing: please also do the same with the vanilla v2.6.22 kernel, 
> and send me that file too. (so that the two cases can be compared)

I put the log files here:
http://www.cyrius.com/tmp/2.6.22
http://www.cyrius.com/tmp/2.6.23-rc8-sched-devel

I increased the time ipfer ran to 30 secs since your script runs for
over 15 secs.  I got:

[  3]  0.0-30.0 sec    331 MBytes  92.6 Mbits/sec   2.6.22
vs
[  3]  0.0-30.0 sec    222 MBytes  62.1 Mbits/sec   2.6.23-rc8-sched-devel

-- 
Martin Michlmayr
http://www.cyrius.com/
