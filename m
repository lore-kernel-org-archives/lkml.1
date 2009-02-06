Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbZBFRz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbZBFRz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbZBFRzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:55:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51618 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbZBFRzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:55:23 -0500
Date: Fri, 6 Feb 2009 18:55:18 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090206175517.GR14011@random.random>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com> <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090130061714.GC31209@kroah.com> <20090202220856.GY20323@random.random> <20090203102920.684e7b67.kamezawa.hiroyu@jp.fujitsu.com> <20090203023147.GZ20323@random.random> <20090203115540.86a01273.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203115540.86a01273.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 11:55:40AM +0900, KAMEZAWA Hiroyuki wrote:
> No need to make a patch for copy_hugetlb_page_range() ?
> IMHO, HugeTLB can be write-protected at fork().

Yeah that was entirely correct, thanks Kame! I reproduced it with
libhugetlbfs and verified it fixed it now.
