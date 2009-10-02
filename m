Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbZJBJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbZJBJAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZJBJAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:00:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:59302 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752071AbZJBJAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:00:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+DWuRMag2DmrE+Nbvx4/xl0QD7Ikhe7xdTDMyVgD
	G9tVR7BRn8Hf8x
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
In-Reply-To: <1254473609.6378.24.camel@marge.simson.net>
References: <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
	 <1254341139.7695.36.camel@marge.simson.net>
	 <20090930202447.GA28236@redhat.com>
	 <1254382405.7595.9.camel@marge.simson.net>
	 <20091001185816.GU14918@kernel.dk>
	 <1254464628.7158.101.camel@marge.simson.net>
	 <20091002080417.GG14918@kernel.dk>
	 <1254473609.6378.24.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 11:00:39 +0200
Message-Id: <1254474039.6378.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> WRT my who can overload theory, I instrumented for my own edification.
> 
> Overload totally forbidden, stamps ergo disabled.
> 
> fairness=0  11.3 avg  (ie == virgin source)
> fairness=1   2.8 avg

(oops, quantum was set to 16 as well there.  not that it matters, but
for completeness)

