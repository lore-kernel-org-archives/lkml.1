Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZDXIN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZDXIN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZDXINi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:13:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51370 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZDXINg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oF4YlXtcItnp7O5nbs5oO1aWTW4F4XUvReDHPsqyGe0FG6Rlbj3P1bXl4j/qL84lsV
         9oYbxB3A1jHHC3WFmvzO2I4rfH9UjIP0qePBAymi03D4oEtevnVDTdRJN2b9YaIovthe
         9dTx0dAY5CIQl1ZTfXut5SAOzFvkEgcWVTUGc=
Date: Fri, 24 Apr 2009 10:13:30 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] cgroup: io-throttle controller (v14)
Message-ID: <20090424081329.GA8535@linux>
References: <1240090636-898-1-git-send-email-righi.andrea@gmail.com> <49EC34C1.6010709@cn.fujitsu.com> <20090420144816.GA13307@linux> <49ED1E66.6030604@cn.fujitsu.com> <20090421095848.GB13699@linux> <49EE6E3C.8050409@cn.fujitsu.com> <20090422124328.GA32007@linux> <49EFD948.7050803@cn.fujitsu.com> <20090423101400.GA16768@linux> <49F11177.6000709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F11177.6000709@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 09:10:15AM +0800, Gui Jianfeng wrote:
> Andrea Righi wrote:
> > page_cgroup_*_onwer are defined in mm/page_cgroup.c, that is built if
> > CONFIG_PAGE_TRACKING=y. But from init/Kconfig:
> 
>   page_cgroup_*_onwer also depend on CONFIG_SPARSEMEM, if !defined(CONFIG_SPARSEMEM), 
>   they won't be built. So just move them out of CONFIG_SPARSEMEM block.

You're right! I moved all these functions out of the CONFIG_SPARSEMEM
block. I'll include this fix in the next io-throttle version.

Thanks!!
-Andrea
