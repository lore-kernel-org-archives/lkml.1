Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZHGBKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZHGBKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZHGBKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:10:08 -0400
Received: from [222.73.24.84] ([222.73.24.84]:54358 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZHGBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:10:08 -0400
Message-ID: <4A7B7E9C.6060008@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 09:08:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/filters: Support specifying filter hook to
 a TRACE_EVENT field
References: <4A7A72BD.5030201@cn.fujitsu.com> <alpine.DEB.2.00.0908061022490.9870@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908061022490.9870@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> [PATCH 1/3] tracing/filters: Add filter_type to struct ftrace_event_field
>> [PATCH 2/3] tracing/filters: Add __field_ext() to TRACE_EVENT
>> [PATCH 3/3] tracing/filters: Support filtering for char * strings
> 
> I like the first two patches, but would like to see a V2 with the updates 
> I've mentioned. The last patch I do not fully understand its purpose.
> 

The last one is wanted by Frederic in his bkl trace events patchset:

	http://lkml.org/lkml/2009/8/1/26

In that patch a ptr_str filter hook is always attached to "char *"
field, which is unsafe.

> I'll wait for V2 to pull it in.
> 
