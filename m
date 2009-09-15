Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZIOPMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZIOPMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZIOPMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:12:35 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:37486 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZIOPMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:12:34 -0400
Date: Wed, 16 Sep 2009 00:12:37 +0900 (JST)
Message-Id: <20090916.001237.226784704.ryov@valinux.co.jp>
To: dhaval@linux.vnet.ibm.com
Cc: vgoyal@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       akpm@linux-foundation.org, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090911095347.GD4474@linux.vnet.ibm.com>
References: <20090909105122.GF8828@linux.vnet.ibm.com>
	<20090910.165849.104059407.ryov@valinux.co.jp>
	<20090911095347.GD4474@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dhaval,

Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > > I know that cgroup is a very well defined functionality, that is why
> > > > dm-ioband also supports throttling per cgroup. But how are we supposed
> > > > to do throttling on the system which doesn't support cgroup?
> > > > As I wrote in another mail to Vivek, I would like to make use of
> > > > dm-ioband on RHEL 5.x. 
> > > 
> > > Hi Ryo,
> > > 
> > > I am not sure that upstream should really be worrying about RHEL 5.x.
> > > cgroups is a relatively mature solution and is available in most (if not
> > > all) community distros today. We really should not be looking at another
> > > grouping solution if the sole reason is that then dm-ioband can be used
> > > on RHEL 5.x. The correct solution would be to maintain a separate patch
> > > for RHEL 5.x then and not to burden the upstream kernel.
> > 
> > RHEL 5.x is not the sole reason for that.
> > 
> 
> Could you please enumerate the other reasons for pushing in another
> grouping mechanism then? (Why can we not resolve them via cgroups?)

I'm sorry for late reply.

I'm not only pushing in the grouping mechanism by using the dmsetup
command. Please understand that dm-ioband also provides cgroup
interface and can be configured in the same manner like other cgroup
subsystems.
Why it is so bad to have multiple ways to configure? I think that it
rather gains in flexibility of configurations.

Thanks,
Ryo Tsuruta
