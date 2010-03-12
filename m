Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0CLAHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:07:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57536 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0CLAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:07:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 12 Mar 2010 09:03:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-Id: <20100312090326.ad07c05c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100311235922.GA4569@linux>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
	<20100311180753.GE29246@redhat.com>
	<20100311235922.GA4569@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 00:59:22 +0100
Andrea Righi <arighi@develer.com> wrote:

> On Thu, Mar 11, 2010 at 01:07:53PM -0500, Vivek Goyal wrote:
> > On Wed, Mar 10, 2010 at 12:00:31AM +0100, Andrea Righi wrote:

> mmmh.. strange, on my side I get something as expected:
> 
> <root cgroup>
> $ dd if=/dev/zero of=test bs=1M count=500
> 500+0 records in
> 500+0 records out
> 524288000 bytes (524 MB) copied, 6.28377 s, 83.4 MB/s
> 
> <child cgroup with 100M memory.limit_in_bytes>
> $ dd if=/dev/zero of=test bs=1M count=500
> 500+0 records in
> 500+0 records out
> 524288000 bytes (524 MB) copied, 11.8884 s, 44.1 MB/s
> 
> Did you change the global /proc/sys/vm/dirty_* or memcg dirty
> parameters?
> 
what happens when bs=4k count=1000000 under 100M ? no changes ?

-Kame

