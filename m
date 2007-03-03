Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXCCJjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXCCJjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 04:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXCCJi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 04:38:59 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53406 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXCCJi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 04:38:58 -0500
Date: Sat, 3 Mar 2007 15:08:24 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Balbir Singh <balbir@in.ibm.com>
Cc: menage@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       sam@vilain.net, ebiederm@xmission.com, winget@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 1/2] rcfs core patch
Message-ID: <20070303093824.GB1028@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com> <45E7B0E9.3040202@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E7B0E9.3040202@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 10:36:49AM +0530, Balbir Singh wrote:
> With this don't we end up with a lot of duplicate between cpusets and rcfs.

Unless we remove the duplication in cpusets and make it work with
rcfs/containers!

I wonder if we can avoid so much of filesystem code and use something
like configfs to configure the resource objects. In particular I dont
know if, using configfs, it is possible to provide a multi-hierarchy feature 
(each hierarchy bound to separate set of controllers)

> > linux-2.6.20-vatsa/include/linux/init_task.h |    4 
> > linux-2.6.20-vatsa/include/linux/nsproxy.h   |    5 
> > linux-2.6.20-vatsa/init/Kconfig              |   22 
> > linux-2.6.20-vatsa/init/main.c               |    1 
> > linux-2.6.20-vatsa/kernel/Makefile           |    1 
> >
> >
> >---
> 
> The diffstat does not look quite right.

Hmm that was generated using refpatch. Will find out what went wrong.

-- 
Regards,
vatsa
