Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbZDQG7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbZDQG7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759513AbZDQG66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:58:58 -0400
Received: from gw.goop.org ([64.81.55.164]:59350 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbZDQG65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:58:57 -0400
Message-ID: <49E828B0.90402@goop.org>
Date: Thu, 16 Apr 2009 23:58:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: mathieu.desnoyers@polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/4] tracing: pass proto and args to DEFINE_TRACE
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-4-git-send-email-jeremy@goop.org> <20090417064820.GA20685@infradead.org>
In-Reply-To: <20090417064820.GA20685@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Apr 16, 2009 at 11:35:38PM -0700, Jeremy Fitzhardinge wrote:
>   
>> -DEFINE_TRACE(power_mark);
>> +DEFINE_TRACE(power_mark,
>> +	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
>> +	      TP_ARGS(it, type, state));
>>     
>
> Wrong indentation, the TP_ARGS should have the same level of indentation
> (one) as the TP_PROTO.  Also true for all others.
>   

It's just cut+replace+paste from the DECLARE_TRACE() definitions in 
trace/power.h.  The proper fix is to not duplicate all that stuff in the 
first place, but I didn't want to introduce a gratuitous re-indent in 
the process.

    J

