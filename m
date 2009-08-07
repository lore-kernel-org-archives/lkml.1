Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZHGCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZHGCrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZHGCrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:47:16 -0400
Received: from [222.73.24.84] ([222.73.24.84]:60949 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZHGCrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:47:16 -0400
Message-ID: <4A7B9559.5000003@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 10:45:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH v2 2/3] tracing/filters: Add __field_ext() to TRACE_EVENT
References: <4A7B9242.7010204@cn.fujitsu.com> <4A7B9272.6050709@cn.fujitsu.com> <alpine.DEB.2.00.0908062242220.2840@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908062242220.2840@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  #define is_signed_type(type)	(((type)(-1)) < 0)
>>  
>> @@ -165,7 +172,7 @@ do {									\
>>  #define __common_field(type, item, is_signed)				\
>>  	ret = trace_define_field(event_call, #type, "common_" #item,	\
>>  				 offsetof(typeof(field.ent), item),	\
>> -				 sizeof(field.ent.item), is_signed);	\
>> +				 sizeof(field.ent.item), is_signed, -1);\
> 
> I think this wants to be FILTER_OTHER?
> 

oops.. I thought I had changed all -1 to FILTER_OTHER..

I guess you're going to fix this manually?

