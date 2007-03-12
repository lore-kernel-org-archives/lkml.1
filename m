Return-Path: <linux-kernel-owner+w=401wt.eu-S965866AbXCLOEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866AbXCLOEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965862AbXCLOEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:04:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56568 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965866AbXCLOEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:04:35 -0400
Date: Mon, 12 Mar 2007 19:41:44 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, sam@vilain.net, dev@sw.ru, xemul@sw.ru,
       pj@sgi.com, ebiederm@xmission.com, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070312141144.GB10450@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070307215919.GA2110@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307215919.GA2110@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 03:59:19PM -0600, Serge E. Hallyn wrote:
> > containers patches uses just a single pointer in the task_struct, and
> > all tasks in the same set of containers (across all hierarchies) will
> > share a single container_group object, which holds the actual pointers
> > to container state.
> 
> Yes, that's why this consolidation doesn't make sense to me.
> 
> Especially considering again that we will now have nsproxies pointing to
> containers pointing to... nsproxies.

nsproxies needn't point to containers. It (or as Herbert pointed -
nsproxy->pid_ns) can have direct pointers to resource objects (whatever
struct container->subsys[] points to).


-- 
Regards,
vatsa
