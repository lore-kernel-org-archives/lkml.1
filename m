Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXIZKXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXIZKXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXIZKXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:23:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:38048 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754561AbXIZKXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:23:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18RB4sm6UYRi1KFx1Ua4PhlpW7CwceTxkEzoE48tl
	LjVltowafzwNdz
Subject: Re: Network slowdown due to CFS
From: Mike Galbraith <efault@gmx.de>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070926085202.GE3337@deprecation.cyrius.com>
References: <20070926085202.GE3337@deprecation.cyrius.com>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 12:23:28 +0200
Message-Id: <1190802208.7318.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 10:52 +0200, Martin Michlmayr wrote:
> I noticed that my network performance has gone down from 2.6.22
> >from   [  3]  0.0-10.0 sec    113 MBytes  95.0 Mbits/sec
> to     [  3]  0.0-10.0 sec   75.7 MBytes  63.3 Mbits/sec
> with 2.6.23-rc1 (and 2.6.23-rc8), as measured with iperf.
> 
> I did a git bisect today and tracked it back to the commit where CFS
> was enabled ("sched: cfs core code; apply the CFS core code",
> commit dd41f596cda0d7d6e4a8b139ffdfabcefdd46528).  I also compiled a
> kernel from
> git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> but things don't improve.
> 
> This is on a Thecus N2100, an ARM (Intel IOP32x) based storage device
> with a r8169 card, SATA disks and 512 MB RAM.  My config is attached.
> 
> What kind of information can I supply so you can track this down?

I noticed on the iperf website a patch which contains sched_yield().

http://dast.nlanr.net/Projects/Iperf2.0/patch-iperf-linux-2.6.21.txt

Do you have that patch applied by any chance?  If so, it might be a
worth while to try it without it.

	-Mike

