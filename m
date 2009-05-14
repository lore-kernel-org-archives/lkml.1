Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbZENQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbZENQoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZENQn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:43:58 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:59876 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbZENQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:43:57 -0400
Date: Thu, 14 May 2009 22:13:49 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, agk@redhat.com,
       dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com,
       peterz@infradead.org, Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: IO scheduler based IO Controller V2
Message-ID: <20090514164349.GA22833@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090506213453.GC4282@linux> <20090506215235.GJ8180@redhat.com> <20090507090450.GA4613@linux> <20090507141126.GA9463@redhat.com> <20090507144501.GB9463@redhat.com> <20090507153642.GC9463@redhat.com> <20090507221900.GA29774@linux> <20090508180951.GG7293@redhat.com> <20090508200458.GA3708@linux> <20090508215618.GJ7293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508215618.GJ7293@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:56:18PM -0400, Vivek Goyal wrote:

>   So, we shall have to come up with something better, I think Dhaval was
>   implementing upper limit for cpu controller. May be PeterZ and Dhaval can
>   give us some pointers how did they manage to implement both proportional
>   and max bw control with the help of a single tree while maintaining the
>   notion of prio with-in cgroup.
> 
> PeterZ/Dhaval  ^^^^^^^^
> 

We still haven't :). I think the idea is to keep fairness (or
propotion) between the groups that are currently running. The throttled
groups should not be considered.

thanks,
-- 
regards,
Dhaval
