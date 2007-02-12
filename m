Return-Path: <linux-kernel-owner+w=401wt.eu-S965441AbXBLWra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbXBLWra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965439AbXBLWra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:47:30 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33282 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965441AbXBLWr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:27 -0500
Date: Mon, 12 Feb 2007 16:47:17 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sam Vilain <sam@vilain.net>
Cc: menage@google.com, akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com,
       dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, vatsa@in.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Message-ID: <20070212224717.GB19604@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <45D0EC68.9090009@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D0EC68.9090009@vilain.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sam Vilain (sam@vilain.net):
> menage@google.com wrote:
> > Generic Process Containers
> > --------------------------
> >
> > There have recently been various proposals floating around for
> > resource management/accounting and other task grouping subsystems in
> > the kernel, including ResGroups, User BeanCounters, NSProxy
> > containers, and others.  These all need the basic abstraction of being
> > able to group together multiple processes in an aggregate, in order to
> > track/limit the resources permitted to those processes, or control
> > other behaviour of the processes, and all implement this grouping in
> > different ways.
> >   
> 
> I know I'm a bit out of touch, but AIUI the NSProxy *is* the container. 

The nsproxy is an implementation detail, actually, and might go away at
any time.  But yes we had been talking for quite awhile about sets of
namespaces as containers, so that a vserver would be a container, as
would a lightweight checkpoint/restart job.

> We decided a long time ago that a container was basically just a set of
> namespaces, which includes all of the subsystems you mention.
> 
> This would suggesting re-write this patchset, part 2 as a "CPUSet

Well it's an unfortunate conflict, but I don't see where we have any
standing to make Paul change his terminology  :)

Lately I've been talking about "Paul's containers", our "namespaces",
and the "namespace container subsystem" in patch 7.

> namespace", part 4 as a "CPU scheduling namespace", parts 5 and 6 as
> "Resource Limits Namespace" (drop this "BeanCounter" brand), and of
> course part 7 falls away.

Part 7 does not fall away, it uses Paul's patchset to start to provide
a management interface for namespaces.

-serge
