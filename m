Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZCFVyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZCFVyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZCFVyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:54:11 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:33915 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZCFVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:54:10 -0500
Message-ID: <49B19B6A.8060608@nortel.com>
Date: Fri, 06 Mar 2009 15:53:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [Patch] mm tracepoints
References: <1233306324.11332.11.camel@nigel-laptop>	 <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com>	 <20090306105627.3EF0.A69D9226@jp.fujitsu.com>	 <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com>	 <20090306110423.GD21168@elte.hu>	 <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com>	 <20090306135547.GB21907@elte.hu>	 <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>	 <20090306171016.GA32128@elte.hu> <1236361106.6326.595.camel@laptop>
In-Reply-To: <1236361106.6326.595.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 21:53:48.0259 (UTC) FILETIME=[07650330:01C99EA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2009-03-06 at 18:10 +0100, Ingo Molnar wrote:
>> Looks pretty good and useful to me. I've Cc:-ed more mm folks, 
>> it would be nice to hear their opinion about these tracepoints.
>>
>> Andrew, Nick, Peter, what do you think?
> 
> Bit sad we use the struct mm_struct * as mm identifier (little %lx vs %p
> confusion there too), but I suppose there simply isn't anything better.

Could we use the tgid as an mm identifier?  Or does the possibility of 
CLONE_VM & !CLONE_THREAD preclude this?

Chris
