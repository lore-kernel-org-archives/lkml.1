Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbYGJR2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbYGJR2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYGJR2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:28:45 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57353 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756233AbYGJR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:28:44 -0400
Date: Thu, 10 Jul 2008 22:57:51 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [Libcg-devel] [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710172751.GC4235@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080701191126.GA17376@redhat.com> <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com> <20080710140624.GB3782@redhat.com> <6599ad830807100941k330bb62cg7ae6a3d611e2dffa@mail.gmail.com> <20080710171939.GB12043@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710171939.GB12043@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:19:39PM -0400, Vivek Goyal wrote:
> On Thu, Jul 10, 2008 at 09:41:06AM -0700, Paul Menage wrote:
> > On Thu, Jul 10, 2008 at 7:06 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > This looks interesting. So above method should solve atleast the
> > > reliability issue of event transport to user space. Got few thougts.
> > >
> > > - Hopefully number of hiearchies will not explode as we will be
> > >  mounting one hierarchies per event type (uid change, gid change,
> > >  exec, maybe fork etc.).
> > 
> > In what circumstances would you want to reclassify processes to a
> > different cgroup on a fork?
> 
> I don't know. Balbir had mentioned in one of the mails in this thread
> regarding getting notification on fork.

fork or exec? I believe reclassifications would happen only on exec.

-- 
regards,
Dhaval
