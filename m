Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbZHSBoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbZHSBoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZHSBoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:44:13 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:41139 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZHSBoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:44:12 -0400
Date: Wed, 19 Aug 2009 10:43:11 +0900 (JST)
Message-Id: <20090819.104311.71088788.ryov@valinux.co.jp>
To: vgoyal@redhat.com
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
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090818142636.GA7367@redhat.com>
References: <1250451046-9966-19-git-send-email-vgoyal@redhat.com>
	<20090818.204212.59676649.ryov@valinux.co.jp>
	<20090818142636.GA7367@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Aug 18, 2009 at 08:42:12PM +0900, Ryo Tsuruta wrote:
> > Hi Vivek,
> > 
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > o blkio_cgroup patches from Ryo to track async bios.
> > > 
> > > o Fernando is also working on another IO tracking mechanism. We are not
> > >   particular about any IO tracking mechanism. This patchset can make use
> > >   of any mechanism which makes it to upstream. For the time being making
> > >   use of Ryo's posting.
> > 
> > The patch attached with your mail is obsolete and it may potentially
> > cause a deadlock when lock_page_cgroup() is called under radix_tree->lock.
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e767e0561d7fd2333df1921f1ab4176211f9036b
> > 
> > The latest blkio-cgroup fixes the above issue and reduces IO tracking
> > overhead since lock_page_cgroup() is no longer used. I would recommend
> > to update to the latest version.
> > 
> 
> Hi Ryo,
> 
> Thanks. In next posting I will move to latest version of io tracking
> patches.
> 
> > And I have a suggestion, how about moving get_cgroup_from_page() to
> > biotrack.c, I think this function would be useful for people who
> > want to make use of the IO tracking mechanism.
> > 
> > Please let me know your opinion.
> 
> Makes sense. In next posting, will move get_cgroup_from_page() to biotrack.c.

Thank you for your reply. I'll post the new blkio-cgroup reflected in
this change by the end of this week. Please use it if you would like to.

Thanks,
Ryo Tsuruta
