Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXCMRvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXCMRvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXCMRvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:51:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44244 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXCMRvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:51:52 -0400
Date: Tue, 13 Mar 2007 23:28:20 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com, xemul@sw.ru, dev@sw.ru, pj@sgi.com, sam@vilain.net,
       ebiederm@xmission.com, winget@google.com, serue@us.ibm.com,
       akpm@linux-foundation.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, ckrm-tech@lists.sourceforge.net
Subject: Re: Summary of resource management discussion
Message-ID: <20070313175820.GA21825@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070312124226.GD17151@in.ibm.com> <20070313162459.GQ8755@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313162459.GQ8755@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 05:24:59PM +0100, Herbert Poetzl wrote:
> what about identifying different resource categories and
> handling them according to the typical usage pattern?
> 
> like the following:
> 
>  - cpu and scheduler related accounting/limits
>  - memory related accounting/limits
>  - network related accounting/limits
>  - generic/file system related accounting/limits
> 
> I don't worry too much about having the generic/file stuff
> attached to the nsproxy, but the cpu/sched stuff might be
> better off being directly reachable from the task

I think we should experiment with both combinations (a direct pointer
to cpu_limit structure from task_struct and an indirect pointer), get
some numbers and then decide. Or do you have results already with
respect to that?

> > 3. How are cpusets related to vserver/containers?
> > 
> > 	Should it be possible to, lets say, create exclusive cpusets and
> > 	attach containers to different cpusets?
> 
> that is what Linux-VServer does atm, i.e. you can put
> an entire guest into a specific cpu set 

Interesting. What abt /dev/cpuset view? Is that same for all containers
or do you restrict that view to the containers cpuset only?

-- 
Regards,
vatsa
