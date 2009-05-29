Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbZE2P6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbZE2P6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761701AbZE2P6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:58:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42712 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762189AbZE2P6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:58:18 -0400
Date: Fri, 29 May 2009 11:53:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 01/20] io-controller: Documentation
Message-ID: <20090529155348.GB26962@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-2-git-send-email-vgoyal@redhat.com> <20090529154252.GD5587@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529154252.GD5587@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 11:42:52PM +0800, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2009-05-26 18:41:50]:
> 
> > +	mount -t cgroup -o io,blkio none /cgroup
> > +
> > +- Create two cgroups
> > +	mkdir -p /cgroup/test1/ /cgroup/test2
> > +
> > +- Set weights of group test1 and test2
> > +	echo 1000 > /cgroup/test1/io.ioprio
> > +	echo 500 > /cgroup/test2/io.ioprio
> > +
> 
> I am not sure if anyone has asked this before, but are the numbers
> arbitrary like shares or are they time units?
> 

They are arbitrary like shares. 

This documentation file is still little wrong. "io.ioprio" should be replaced
with "io.weight". Gui pointed it out last time. Will fix it right away..

Thanks
Vivek
