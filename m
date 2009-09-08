Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbZIHRHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbZIHRHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZIHRHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:07:46 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51024 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZIHRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:07:45 -0400
Date: Tue, 8 Sep 2009 22:36:49 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, riel@redhat.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
Message-ID: <20090908170649.GC8828@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090904231129.GA3689@redhat.com> <20090907.200222.193693062.ryov@valinux.co.jp> <4AA51065.6050000@redhat.com> <20090908.120119.71095369.ryov@valinux.co.jp> <20090908134244.GA15974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908134244.GA15974@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> >   advantage.)
> 
> I think this is more of a disadvantage than advantage. We have a very well
> defined functionality of cgroup in kernel to group the tasks. Now you are
> coming up with your own method of grouping the tasks which will make life
> even more confusing for users and application writers.
> 

I would tend to agree with this. With other resource management
controllers using cgroups, having dm-ioband use something different will
require a different set of userspace tools/libraries to be used.
Something that will severly limit its usefulness froma programmer's
perspective.

thanks,
-- 
regards,
Dhaval
