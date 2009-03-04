Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZCDIsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZCDIsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCDIrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:47:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49443 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZCDIry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:47:54 -0500
Date: Wed, 4 Mar 2009 17:46:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, kenchen@google.com
Subject: Re: [PATCH] remove rq->lock from cpuacct cgroup v2
Message-Id: <20090304174635.43d0f554.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090304172005.99f5b0a2.kamezawa.hiroyu@jp.fujitsu.com>
References: <49A65455.4030204@cn.fujitsu.com>
	<20090227122239.875a3f56.kamezawa.hiroyu@jp.fujitsu.com>
	<1236005770.5330.583.camel@laptop>
	<20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
	<1236066689.18955.27.camel@twins>
	<d4132000000381ebc2ba5c2ffe9bb1bd.squirrel@webmail-b.css.fujitsu.com>
	<1236073236.18955.46.camel@twins>
	<2d4a44772433903887651c0bfe74c9cc.squirrel@webmail-b.css.fujitsu.com>
	<1236081288.5330.4105.camel@laptop>
	<20090304153245.109eada4.kamezawa.hiroyu@jp.fujitsu.com>
	<344eb09a0903032354r38d74c48p217d338cba7159e8@mail.gmail.com>
	<20090304172005.99f5b0a2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 17:20:05 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 4 Mar 2009 13:24:43 +0530
> Bharata B Rao <bharata.rao@gmail.com> wrote:
> At first, generic per-cpu counter sounds interesting but to be honest,
> some special handling is used for cpuacct based on its characteristic.
> 
>   - Writer works under non-preemptable context.
>   - There is only one writer.
> 
If utime/stime updates works on above context, using the same code will be good.

I don't use any cpuacct structure specific in routines...
If you want me to rewrite it, I'll do. please request what you want.

Thanks,
-Kame 

