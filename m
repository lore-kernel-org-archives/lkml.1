Return-Path: <linux-kernel-owner+w=401wt.eu-S1767377AbXCIQeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767377AbXCIQeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767375AbXCIQeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:34:14 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47297 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767378AbXCIQeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:34:12 -0500
Date: Fri, 9 Mar 2007 22:11:18 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       sam@vilain.net, dev@sw.ru, xemul@sw.ru, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070309164118.GO6504@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309163430.GN6504@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 10:04:30PM +0530, Srivatsa Vaddagiri wrote:
> 2. Regarding space savings, if 100 tasks are in a container (I dont know
>    what is a typical number) -and- lets say that all tasks are to share
>    the same resource allocation (which seems to be natural), then having
>    a 'struct container_group *' pointer in each task_struct seems to be not 
>    very efficient (simply because we dont need that task-level granularity of
>    managing resource allocation).

Note that this 'struct container_group *' pointer is in addition to the
'struct nsproxy *' pointer already in task_struct. If the set of tasks
over which resorce control is applied is typically the same set of tasks
which share the same 'struct nsproxy *' pointer, then IMHO 'struct
container_group *' in each task_struct is not very optimal.

-- 
Regards,
vatsa
