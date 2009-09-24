Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZIXQIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZIXQIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZIXQIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:08:09 -0400
Received: from ms01.sssup.it ([193.205.80.99]:43293 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752622AbZIXQII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:08:08 -0400
Message-ID: <4ABB9964.7050104@evidence.eu.com>
Date: Thu, 24 Sep 2009 18:08:04 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raistlin <raistlin@linux.it>, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
References: <1253615424.20345.76.camel@Palantir>	 <4AB8BBEF.2040604@evidence.eu.com> <1253623106.4452.9.camel@laptop>
In-Reply-To: <1253623106.4452.9.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra ha scritto:
> On Tue, 2009-09-22 at 13:58 +0200, Claudio Scordino wrote:
>>> This implementation is part of a FP7 European project called ACTORS,
>>> and financially supported by the European commission
>>> (see http://www.actors-project.eu).
>>>
>>> The involved partners (which include Ericsson Research, Evidence Srl,
>>> AKAtech) strongly believe that a general-purpose operating system like
>>> Linux should provide a standard real-time scheduling policy (like the
>>> one implemented in this patch) still allowing to schedule non-real-time
>>> tasks in the usual way.
>> Hi Peter, hi all,
>>
>>       note that the request of having an EDF scheduling class integrated 
>> in the mainline kernel does not come from academy, but comes from industry.
> 
> Yeah, I know, there's lots of interest in having a deadline scheduler.
> 
> One of the things we'll have to look at is removing all the EDF
> assumptions from it.
> 
> I think we'll be wanting to do something like s/EDF/DEADLINE/
> s/edf/deadline/ etc. on the code base to begin with.

This is easy: we can give it whatever name you want :)

Are you suggesting to use "SCHED_DEADLINE" ?

Cheers,

                 Claudio

