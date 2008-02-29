Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbYB2SGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbYB2SGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbYB2SGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:06:35 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22941 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbYB2SGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:06:34 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5242"; a="1029451"
Message-ID: <47C849A7.7020607@qualcomm.com>
Date: Fri, 29 Feb 2008 10:06:31 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080229003155.bbab795d.akpm@linux-foundation.org> <20080229091018.GA19823@elte.hu>
In-Reply-To: <20080229091018.GA19823@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> It of course lays waste to a series of cgroup patches from Paul Menage 
>> which I already had queued.
> 
> Andrew, please stop tracking sched-devel.git and track this tree 
> instead:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Another option is to have cpusets or cpu isolation tree that I've started 
already. I was saying from the very beginning cpu isolation stuff does not 
imho belong in the scheduler tree. Besides a tiny patch to the sched.c that 
adds/removes the bitmaps there are no scheduler changes needed for this 
specifically.

Peter, Ingo, if you guys are ok with this lets just have this stuff in 
cpuisol-2.6.git. I'm anyway rebasing it ontop of Peter's work. Of course we'll 
go through regular review and stuff and Andrew can track that tree separately.

Just a suggestion. I'm ok with submitting patches via sched-devel. Separate 
tree seems more appropriate though.

Max
