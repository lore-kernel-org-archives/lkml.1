Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbZDQNtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbZDQNtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbZDQNth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:49:37 -0400
Received: from gw.goop.org ([64.81.55.164]:36863 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZDQNtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:49:36 -0400
Message-ID: <49E888EE.6000003@goop.org>
Date: Fri, 17 Apr 2009 06:49:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mathieu.desnoyers@polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] WIP pvops trace events
References: <1239950374-1252-1-git-send-email-jeremy@goop.org> <20090417084356.GA28417@elte.hu>
In-Reply-To: <20090417084356.GA28417@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This is my series of pvops tracing patches, consisting of:
>>
>> - Split out asm/paravirt_type.h from asm/paravirt.h, so that
>>   trace/events/pvops.h can include the types without getting everything
>>   else.
>>     
>
> Ob'sidenote: seems like tracing is driving include file dependency 
> cleanups! The law of unintended consequences (of the positive 
> variety).

The tracing stuff is making the C preprocessor cower and wimper like a 
beaten puppy, so we need to do something to help it...

    J
