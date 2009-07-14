Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZGNF4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZGNF4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 01:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZGNF4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 01:56:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43869 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZGNF4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 01:56:44 -0400
Date: Tue, 14 Jul 2009 11:26:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitzu.com, bblum@google.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
Message-ID: <20090714055638.GI5051@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com> <20090705063850.GX11273@balbir.in.ibm.com> <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com> <20090713121138.GC5051@balbir.in.ibm.com> <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* menage@google.com <menage@google.com> [2009-07-13 09:26:26]:

> On Mon, Jul 13, 2009 at 5:11 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
> >
> > How about lazy migration? Mark a group as to move when the kernel sees
> > it next for scheduling.
> 
> Waiting for the next scheduling point might be too long, since a
> thread can block for arbitrary amounts of time and keeping the marker
> around for arbitrary time (unless we add a new task_struct field)
> would be tricky. Marking the cgroup or tgid as being migrated which
> then triggers the extra synchronization in the fork path (but which
> isn't needed at other times) is probably where we'll end up.


Hmm... but we would not need that information till we schedule the
tasks, adding a field to task_struct is what I had in mind.

-- 
	Balbir
