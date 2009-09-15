Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZIOPT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZIOPT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZIOPT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:19:58 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45613 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZIOPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:19:57 -0400
Date: Tue, 15 Sep 2009 20:49:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dhaval@linux.vnet.ibm.com, vgoyal@redhat.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: Regarding dm-ioband tests
Message-ID: <20090915151952.GH4846@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090909105122.GF8828@linux.vnet.ibm.com>
 <20090910.165849.104059407.ryov@valinux.co.jp>
 <20090911095347.GD4474@linux.vnet.ibm.com>
 <20090916.001237.226784704.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090916.001237.226784704.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-16 00:12:37]:

> Hi Dhaval,
> 
> Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > > > I know that cgroup is a very well defined functionality, that is why
> > > > > dm-ioband also supports throttling per cgroup. But how are we supposed
> > > > > to do throttling on the system which doesn't support cgroup?
> > > > > As I wrote in another mail to Vivek, I would like to make use of
> > > > > dm-ioband on RHEL 5.x. 
> > > > 
> > > > Hi Ryo,
> > > > 
> > > > I am not sure that upstream should really be worrying about RHEL 5.x.
> > > > cgroups is a relatively mature solution and is available in most (if not
> > > > all) community distros today. We really should not be looking at another
> > > > grouping solution if the sole reason is that then dm-ioband can be used
> > > > on RHEL 5.x. The correct solution would be to maintain a separate patch
> > > > for RHEL 5.x then and not to burden the upstream kernel.
> > > 
> > > RHEL 5.x is not the sole reason for that.
> > > 
> > 
> > Could you please enumerate the other reasons for pushing in another
> > grouping mechanism then? (Why can we not resolve them via cgroups?)
> 
> I'm sorry for late reply.
> 
> I'm not only pushing in the grouping mechanism by using the dmsetup
> command. Please understand that dm-ioband also provides cgroup
> interface and can be configured in the same manner like other cgroup
> subsystems.
> Why it is so bad to have multiple ways to configure? I think that it
> rather gains in flexibility of configurations.
>

The main issue I see is user confusion and distro issues. If a distro
compiles cgroups and dmsetup provides both methods, what method
do we recommend to end users? Also should system management tool
support two configuration mechanisms for the same functionality?
 

-- 
	Balbir
