Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbYBTPHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbYBTPHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYBTPHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:07:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYBTPHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:07:45 -0500
Message-ID: <47BC40FA.6020205@redhat.com>
Date: Wed, 20 Feb 2008 10:02:18 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ftrace causing panics.
References: <20080219124222.GB13780@linux.vnet.ibm.com> <20080219140352.GB9965@elte.hu> <20080219155433.GA4754@linux.vnet.ibm.com> <20080219161608.GA1347@elte.hu> <20080219173839.GF4754@linux.vnet.ibm.com>
In-Reply-To: <20080219173839.GF4754@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> Hi Ingo,
> 
> ftrace-cmd in -w option when being run for sometime cause this.
> 
> 
> llm11.in.ibm.com login: [ 1002.937490] BUG: unable to handle kernel paging request at 285b0010
> [ 1002.947087] IP: [<c015f7b5>] find_next_entry+0x4f/0x84
> 

Dhaval,

First, thanks for testing!!!!

Are you running the -mm kernel or sched-devel?  This will let me know 
which version you have.  I'm working on a queue of fixes for Ingo now, 
to incorporate into sched-devel (and later pass to Andrew for -mm).  I'm 
not sure if the new fixes will help you, but we need to get in sync, so 
that we are both looking at the same version of the code.

Thanks,

-- Steve
