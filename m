Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZFIOAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZFIOAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZFIN7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:59:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48643 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZFIN7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:59:54 -0400
Date: Tue, 9 Jun 2009 09:52:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [RFC] IO scheduler based IO controller V4
Message-ID: <20090609135256.GA13476@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <4A2DE381.6090205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2DE381.6090205@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 12:22:25PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > Hi All,
> > 
> > Here is the V4 of the IO controller patches generated on top of 2.6.30-rc8.
> > 
> 
> Hi Vivek,
> 
> I can't apply the patchset.
> 
> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/1.eml
> Applying io-controller: Documentation
> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/2.eml
> Applying io-controller: Common flat fair queuing code in elevaotor layer
> error: patch failed: block/Makefile:15
> error: block/Makefile: patch does not apply
> Patch failed at 0001.
> When you have resolved this problem run "git-am --resolved".
> If you would prefer to skip this patch, instead run "git-am --skip".

Hi Gui,

This is strange. It seems to be applying cleanly for me. Can you please
recheck your setup and also see why it is failing. In block/Makefile,
there is one line change and recently no change has taken to that file
in git.

Thanks
Vivek

[vgoyal@machine linux-2.6]$ git-am /tmp/V4/ioc-v4 
Applying: io-controller: Documentation
Applying: io-controller: Common flat fair queuing code in elevaotor layer
Applying: io-controller: Charge for time slice based on average disk rate
Applying: io-controller: Modify cfq to make use of flat elevator fair
queuing
Applying: io-controller: Common hierarchical fair queuing code in
elevaotor layer
Applying: io-controller: cfq changes to use hierarchical fair queuing code
in elevaotor layer
Applying: io-controller: Export disk time used and nr sectors dipatched
through cgroups
Applying: io-controller: idle for sometime on sync queue before expiring
it
Applying: io-controller: Separate out queue and data
Applying: io-conroller: Prepare elevator layer for single queue schedulers
Applying: io-controller: noop changes for hierarchical fair queuing
Applying: io-controller: deadline changes for hierarchical fair queuing
Applying: io-controller: anticipatory changes for hierarchical fair
queuing
Applying: blkio_cgroup patches from Ryo to track async bios.
Applying: io-controller: map async requests to appropriate cgroup
Applying: io-controller: Per cgroup request descriptor support
Applying: io-controller: Support per cgroup per device weights and io
class
Applying: io-controller: Debug hierarchical IO scheduling
Applying: io-controller: experimental debug patch for async queue wait
before expiry


