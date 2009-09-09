Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZIITB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZIITB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZIITBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:01:25 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:32923 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZIITBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:01:25 -0400
Message-ID: <4AA7FB13.9060603@nortel.com>
Date: Wed, 09 Sep 2009 12:59:31 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Theodore Tso <tytso@mit.edu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Turn off child_runs_first
References: <1252486344.28645.18.camel@marge.simson.net> <tip-2bba22c50b06abe9fd0d23933b1e64d35b419262@git.kernel.org> <20090909175724.GY22901@mit.edu> <20090909180856.GA7323@elte.hu>
In-Reply-To: <20090909180856.GA7323@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2009 19:00:18.0627 (UTC) FILETIME=[C6047930:01CA317F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 12:08 PM, Ingo Molnar wrote:
> 
> * Theodore Tso <tytso@mit.edu> wrote:

>> Wasn't one of the reasons why we historically did child_runs_first 
>> was so that for fork/exit workloads, the child has a chance to 
>> exec the new process?  If the parent runs first, then more pages 
>> will probably need to be COW'ed.
> 
> That kind of workload should be using vfork() anyway, and be even 
> faster because it can avoid the fork overhead, right?

According to my man page, POSIX.1-2008 removes the specification  of
vfork().

Chris
