Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbZHRO12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbZHRO12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZHRO12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:27:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47934 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZHRO11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:27:27 -0400
Date: Tue, 18 Aug 2009 10:26:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com,
       agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       jmarchan@redhat.com
Subject: Re: [PATCH 18/24] blkio_cgroup patches from Ryo to track async
	bios.
Message-ID: <20090818142636.GA7367@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-19-git-send-email-vgoyal@redhat.com> <20090818.204212.59676649.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818.204212.59676649.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 08:42:12PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > o blkio_cgroup patches from Ryo to track async bios.
> > 
> > o Fernando is also working on another IO tracking mechanism. We are not
> >   particular about any IO tracking mechanism. This patchset can make use
> >   of any mechanism which makes it to upstream. For the time being making
> >   use of Ryo's posting.
> 
> The patch attached with your mail is obsolete and it may potentially
> cause a deadlock when lock_page_cgroup() is called under radix_tree->lock.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e767e0561d7fd2333df1921f1ab4176211f9036b
> 
> The latest blkio-cgroup fixes the above issue and reduces IO tracking
> overhead since lock_page_cgroup() is no longer used. I would recommend
> to update to the latest version.
> 

Hi Ryo,

Thanks. In next posting I will move to latest version of io tracking
patches.

> And I have a suggestion, how about moving get_cgroup_from_page() to
> biotrack.c, I think this function would be useful for people who
> want to make use of the IO tracking mechanism.
> 
> Please let me know your opinion.

Makes sense. In next posting, will move get_cgroup_from_page() to biotrack.c.

Thanks
Vivek
