Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZGUWMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZGUWMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZGUWMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:12:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:48009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZGUWMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:12:20 -0400
Message-ID: <4A663DC7.4060600@kernel.org>
Date: Wed, 22 Jul 2009 07:14:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Subject: Re: [RFC PATCH] ia64: convert to dynamic percpu allocator
References: <4A65B0AB.5000608@kernel.org> <A6AD88C3F2289247BE726C37303E1EB8B097D4C5@orsmsx505.amr.corp.intel.com>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B097D4C5@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 22:12:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Yu, Fenghua wrote:
>> This patch is available in the following git tree.
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-ia64
> 
> Is this patch against the latest linux-next? It's applied cleanly on
> linux-next. But compilation reports undefined function
> pcpu_alloc_alloc_info() in both contig.c and discontig.c.

Oh, it's on top of percpu#for-next + 20 patches to implement sparse
embedding[1].  I think it would be the easiest to fetch the above git
tree.

Thanks.

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cross-arch/4124
