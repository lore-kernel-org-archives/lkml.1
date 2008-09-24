Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbYIXOy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbYIXOy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYIXOyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:54:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYIXOyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:54:51 -0400
Date: Wed, 24 Sep 2008 10:53:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: ryov@valinux.co.jp, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       righi.andrea@gmail.com, jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
Message-ID: <20080924145331.GD547@redhat.com>
References: <20080919131019.GA3606@redhat.com> <20080922.183651.62951479.taka@valinux.co.jp> <20080922143042.GA19222@redhat.com> <20080924.193414.22923673.taka@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924.193414.22923673.taka@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 07:34:14PM +0900, Hirokazu Takahashi wrote:
> Hi,
> 
> > > It's possible the algorithm of dm-ioband can be placed in the block layer
> > > if it is really a big problem.
> > > But I doubt it can control every control block I/O as we wish since
> > > the interface the cgroup supports is quite poor.
> > 
> > Had a question regarding cgroup interface. I am assuming that in a system,
> > one will be using other controllers as well apart from IO-controller.
> > Other controllers will be using cgroup as a grouping mechanism.
> > Now coming up with additional grouping mechanism for only io-controller seems
> > little odd to me. It will make the job of higher level management software
> > harder.
> > 
> > Looking at the dm-ioband grouping examples given in patches, I think cases
> > of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
> > cgroup and making sure applications are launched/moved into right cgroup by
> > user space tools. 
> 
> Grouping in pid, pgrp and uid is not the point, which I've been thinking
> can be replaced with cgroup once the implementation of bio-cgroup is done.
> 
> I think problems of cgroup are that they can't support lots of storages
> and hotplug devices, it just handle them as if they were just one resource.
> I don't insist the interface of dm-ioband is the best. I just hope the
> cgroup infrastructure support this kind of resources.
> 

Sorry, I did not understand fully. Can you please explain in detail what
kind of situation will not be covered by cgroup interface.

Thanks
Vivek
