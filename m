Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbYBTPeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbYBTPeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765313AbYBTP2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:28:34 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:45946 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932324AbYBTP20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:28:26 -0500
Date: Wed, 20 Feb 2008 20:58:15 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ftrace causing panics.
Message-ID: <20080220152815.GB1082@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080219124222.GB13780@linux.vnet.ibm.com> <20080219140352.GB9965@elte.hu> <20080219155433.GA4754@linux.vnet.ibm.com> <20080219161608.GA1347@elte.hu> <20080219173839.GF4754@linux.vnet.ibm.com> <47BC40FA.6020205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC40FA.6020205@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:02:18AM -0500, Steven Rostedt wrote:
> Dhaval Giani wrote:
>> Hi Ingo,
>>
>> ftrace-cmd in -w option when being run for sometime cause this.
>>
>>
>> llm11.in.ibm.com login: [ 1002.937490] BUG: unable to handle kernel paging request at 285b0010
>> [ 1002.947087] IP: [<c015f7b5>] find_next_entry+0x4f/0x84
>>
>
> Dhaval,
>
> First, thanks for testing!!!!
>

If it helps solve difficult problems, its the best tool ever! :)

> Are you running the -mm kernel or sched-devel?  This will let me know which 
> version you have.  I'm working on a queue of fixes for Ingo now, to 
> incorporate into sched-devel (and later pass to Andrew for -mm).  I'm not 
> sure if the new fixes will help you, but we need to get in sync, so that we 
> are both looking at the same version of the code.
>

sched-devel as of yesterday. (I don't think anything new has gone in
today).

[sorry, not had enough time to get to the bottom of this the last few
days]

-- 
regards,
Dhaval
