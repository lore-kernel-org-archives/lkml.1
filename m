Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbXGJLUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbXGJLUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXGJLT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:19:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbXGJLT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:19:58 -0400
Date: Tue, 10 Jul 2007 13:19:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, containers@lists.osdl.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070710111928.GA15270@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710105240.GA20914@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710105240.GA20914@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
> > cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
> > containersv10-basic-container-framework.patch
> > containersv10-basic-container-framework-fix.patch
> > containersv10-basic-container-framework-fix-2.patch
> > containersv10-basic-container-framework-fix-3.patch
> > containersv10-basic-container-framework-fix-for-bad-lock-balance-in-containers.patch
> > containersv10-example-cpu-accounting-subsystem.patch
> > containersv10-example-cpu-accounting-subsystem-fix.patch
> > containersv10-add-tasks-file-interface.patch
> > containersv10-add-tasks-file-interface-fix.patch
> > containersv10-add-tasks-file-interface-fix-2.patch
> > containersv10-add-fork-exit-hooks.patch
> > containersv10-add-fork-exit-hooks-fix.patch
> > containersv10-add-container_clone-interface.patch
> > containersv10-add-container_clone-interface-fix.patch
> > containersv10-add-procfs-interface.patch
> > containersv10-add-procfs-interface-fix.patch
> > containersv10-make-cpusets-a-client-of-containers.patch
> > containersv10-make-cpusets-a-client-of-containers-whitespace.patch
> > containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
> > containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
> > containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
> > containersv10-simple-debug-info-subsystem.patch
> > containersv10-simple-debug-info-subsystem-fix.patch
> > containersv10-simple-debug-info-subsystem-fix-2.patch
> > containersv10-support-for-automatic-userspace-release-agents.patch
> > containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
> > add-containerstats-v3.patch
> > add-containerstats-v3-fix.patch
> > update-getdelays-to-become-containerstats-aware.patch
> > containers-implement-subsys-post_clone.patch
> > containers-implement-namespace-tracking-subsystem-v3.patch
> > 
> >  Container stuff.  Hold, I guess.  I was expecting updates from Paul.
> 
> Paul,
> 	Are you working on a new version? I thought it was mostly ready
> for mainline.

in particular CONFIG_FAIR_GROUP_SCHED depends on these APIs. Once the 
APIs to configure are upstream, the group scheduler can be enabled too. 
(basically all the group scheduling bits are upstream now as part of 
CFS.)

	Ingo
