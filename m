Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYH0S4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYH0S4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYH0S4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:56:11 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:53991 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYH0S4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:56:10 -0400
Message-ID: <48B5A33A.507@nortel.com>
Date: Wed, 27 Aug 2008 12:55:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mark Hounschell <markh@compro.net>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
References: <20080819103301.787700742@chello.nl> <200808261900.07383.nickpiggin@yahoo.com.au> <20080826093059.GA471@elte.hu> <200808261954.47987.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de> <48B40975.7080803@compro.net> <20080826230021.GB31444@goodmis.org>
In-Reply-To: <20080826230021.GB31444@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2008 18:55:59.0220 (UTC) FILETIME=[8B409B40:01C90876]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:

> What I would suggest is this.
> 
> 1) Keep the default as the infinite for those that know what they are
>    doing.
> 
> 2) Change the sysctl scripts in the distros to set the default to a sane
>   time that will protect the users.
> 
> An RT app that would break the 10s limit would probably be using busybox
> anyway, so the default for that would be what the kernel comes up with.
> 
> The default the 99% of users would have, is what the distro set it to
> for them.
> 
> This seems like a sane solution to satisfy both camps.


Makes sense to me.  It could even get sent out to users about as fast as 
a new kernel by itself, since they could just add a package dependency 
to update the init scripts when the end-user installs the new kernel 
package.

Anyone messing with the kernel directly is likely 1) smart enough to 
deal with existing FIFO semantics, and 2) able to modify their own init 
scripts to get some additional security if they so desire.

Chris
