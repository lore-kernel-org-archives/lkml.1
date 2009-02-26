Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZBZIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZBZIwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZBZIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:52:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63877 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZBZIwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:52:23 -0500
Message-ID: <49A65854.3040505@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 16:52:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 1/2] New cgroup subsystem API (->initialize())
References: <20090225105730.GA4008@in.ibm.com> <20090225105831.GB4008@in.ibm.com> <49A604BA.9090407@cn.fujitsu.com> <20090226075259.GA3312@in.ibm.com> <20090226084814.GA2739@linux.vnet.ibm.com>
In-Reply-To: <20090226084814.GA2739@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe hierarchical accounting is natural. Since the CPU controller
> divides its bandwidth as per hierarchy, it makes sense for the
> accounting to also be hierarchical. I guess this is a reasonable
> compromise. But how do you still check if the group you are accounting
> for is the root group or not? (Unless I am missing something obvious)
> 

As easy as: if (cgrp->parent == NULL) or if (cgrp == cgrp->top_cgroup)

