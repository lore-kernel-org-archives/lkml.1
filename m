Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272Ab0ASWeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0ASWeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739Ab0ASWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:34:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab0ASWeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:34:05 -0500
Date: Tue, 19 Jan 2010 17:33:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
	pending
Message-ID: <20100119223356.GC4992@redhat.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com> <4e5e476b1001130018n2ad9e830s4a20d922abd4c7bb@mail.gmail.com> <20100113082322.GA24345@sli10-desk.sh.intel.com> <20100113111341.GB3087@redhat.com> <20100114034150.GA3922@sli10-desk.sh.intel.com> <4B4EAB39.1070301@cn.fujitsu.com> <20100114061731.GA23590@sli10-desk.sh.intel.com> <20100114110902.GA15559@redhat.com> <C8EDE645B81E5141A8C6B2F73FD926511499ACE22B@shzsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8EDE645B81E5141A8C6B2F73FD926511499ACE22B@shzsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 08:52:01AM +0800, Li, Shaohua wrote:

[..]
> >Yes cfq_should_idle() can check for async queue and return false.
> >
> >Regarding group loosing fair share, currently all async queues are in root
> >group and not in individual groups, so this particular change should not
> >affect a lot. We will continue to idle on sync-idle and sync-noidle
> >service tree. Only async service tree is the exception.
> >
> >Once we introduce per group async queue in future, we shall have to come
> >up with something else, if need be.
> >
> >So keep this as a separate patch. I think in the presence of mixed
> >workload, (readers and buffered writers), it might give little performance
> >boost. We need to test it though.
> Ok, if you thought this method doesn't break group, here is the updated
> patch. I'm sorry to send the attached patch, my mailbox has trouble.

Hi Shaohua,

I did some testing on cfq group functionality and I did not see any
significant impact of this patch.

I am yet to write some test cases for mixed workload testing and see the
impact of this patch. Will get back to you soon.

Thanks
Vivek
