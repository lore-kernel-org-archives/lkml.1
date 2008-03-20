Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYCTOyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYCTOyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYCTOy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:54:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41232 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYCTOyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:54:25 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <2518745.1206024774536.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 20 Mar 2008 23:52:54 +0900 (JST)
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
Subject: Re: Re: [BUG?] 2.6.25-rc[23]-mm1 cgroup list corruption under load with VM Scalability patches
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2f11576a0803200058k4ee85bf1se6abe272c496c39d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <2f11576a0803200058k4ee85bf1se6abe272c496c39d@mail.gmail.com>
 <1204745828.6244.31.camel@localhost>
	 <6599ad830803051309g22d5b746ta30c4f28a394572c@mail.gmail.com>
	 <1205863811.5032.26.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>  > > list_del corruption in cgroup_exit() on 16 cpu, 32GB ia64 NUMA platfor
m.
>>  > >
>>  > >  I've been seeing this for a while now, but we've had known problems
>>  > >  [page leaks, ...] with the VM scalability series.  Now the system
>>  > >  appears to be running very well with these patches under stress loads
>>  > >  that would hang it or cause OOM kill of tests with plenty of swap spa
ce
>>  > >  left.  Eventually, [after 40-45 minutes], I hit a list corruption in
>>  > >  cgroup_exit().
>>  > >
>>  > >  I can't say for sure that our patches aren't causing this, but I've b
een
>>  > >  unable to keep the system up long enough under the stress load w/o th
e
>>  > >  splitlru+noreclaim patches to hit the problem.
>
>sorry for late responce, I don't notice this thread.
>fujitsu guys investigated that problem too.
>
>AFAIK this problem already fixed KAMEZAWA-san.
>but I don't know that patch merged -mm or not.
>
>kamezawa-san, please let us know its status?

*tons* of fixes by Hugh Dickins is merged now,
could you update your base kernel ? (or set config to N in older kernel)

Thanks
-Kame

