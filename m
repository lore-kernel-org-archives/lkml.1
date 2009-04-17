Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZDQPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZDQPz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZDQPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:55:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42241 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbZDQPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:55:16 -0400
Date: Fri, 17 Apr 2009 17:55:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mathieu.desnoyers@polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] WIP pvops trace events
Message-ID: <20090417155500.GD8253@elte.hu>
References: <1239950374-1252-1-git-send-email-jeremy@goop.org> <20090417084356.GA28417@elte.hu> <49E888EE.6000003@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E888EE.6000003@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>> This is my series of pvops tracing patches, consisting of:
>>>
>>> - Split out asm/paravirt_type.h from asm/paravirt.h, so that
>>>   trace/events/pvops.h can include the types without getting everything
>>>   else.
>>>     
>>
>> Ob'sidenote: seems like tracing is driving include file dependency  
>> cleanups! The law of unintended consequences (of the positive  
>> variety).
>
> The tracing stuff is making the C preprocessor cower and wimper like a  
> beaten puppy, so we need to do something to help it...

'beaten puppy' is not the fitting analogy i believe here.

'tortured bastard' might be closer?

	Ingo
