Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYGJRVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYGJRVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759744AbYGJRU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:20:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759730AbYGJRU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:20:57 -0400
Date: Thu, 10 Jul 2008 13:19:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710171939.GB12043@redhat.com>
References: <20080701191126.GA17376@redhat.com> <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com> <20080710140624.GB3782@redhat.com> <6599ad830807100941k330bb62cg7ae6a3d611e2dffa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830807100941k330bb62cg7ae6a3d611e2dffa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 09:41:06AM -0700, Paul Menage wrote:
> On Thu, Jul 10, 2008 at 7:06 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > This looks interesting. So above method should solve atleast the
> > reliability issue of event transport to user space. Got few thougts.
> >
> > - Hopefully number of hiearchies will not explode as we will be
> >  mounting one hierarchies per event type (uid change, gid change,
> >  exec, maybe fork etc.).
> 
> In what circumstances would you want to reclassify processes to a
> different cgroup on a fork?

I don't know. Balbir had mentioned in one of the mails in this thread
regarding getting notification on fork.

Thanks
Vivek
