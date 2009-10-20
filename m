Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZJTGLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZJTGLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZJTGLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:11:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:40433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZJTGLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:11:35 -0400
Message-ID: <4ADD54D4.70808@kernel.org>
Date: Tue, 20 Oct 2009 15:12:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <4ADD48D1.1040701@kernel.org> <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 20 Oct 2009 06:11:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> So how about something along the lines below? (completely untested as 
> well)
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: sched: move rq_weight data array out of .percpu
> 
> Commit 34d76c41 introduced percpu array update_shares_data, size of which
> being proportional to NR_CPUS. Unfortunately this blows up ia64 for large
> NR_CPUS configuration, as ia64 allows only 64k for .percpu section.
> 
> Fix this by allocating this array dynamically and keep only pointer to it
> percpu.

Looks good to me from percpu POV.

Thanks.

-- 
tejun
