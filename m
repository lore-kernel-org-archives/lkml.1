Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbZCRTT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbZCRTT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZCRTTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:19:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbZCRTTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:19:20 -0400
Message-ID: <49C140F7.9060301@redhat.com>
Date: Wed, 18 Mar 2009 14:44:07 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_W?= =?ISO-8859-1?Q?eisbecker?= 
	<fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Documenting kernel tracepoints
References: <49C122DF.7020803@redhat.com> <20090318164433.GA31315@elte.hu>
In-Reply-To: <20090318164433.GA31315@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * William Cohen <wcohen@redhat.com> wrote:
> 
>> There are a number of tracepoints in the latest kernels, but not 
>> much documentation on the tracepoints.  If a very recent version 
>> of systemtap is available on the system, a list of the probe 
>> points can be obtained with:
>>
>> stap -p2 -e 'probe kernel.trace("*") {exit()}'|sort
>>
>> However, this only provides the names. It doesn't provide 
>> information about what information the probe point provides or the 
>> arguments available at the probe point.
>>
>> Currently, a number of kernel functions and structures are 
>> documented with embedded comments that are extracted with 
>> kernel-doc. Seems like it would be reasonable to extend this to 
>> support tracepoints. Any thoughts or comments about this approach?
> 
> FYI, in the latest tracing tree (targeted for 2.6.30) all 
> tracepoints show up under /debug/tracing/events/.
> 
> 	Ingo

The /debug/tracing/events provides event names and information about the
available arguments. However, it doesn't provide the detail comparable to
kerneldoc embedded comments summarizing the tracepoint's purpose or what the
arguments are.

-Will
