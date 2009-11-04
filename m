Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZKDC73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZKDC73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZKDC72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:59:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbZKDC72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:59:28 -0500
Message-ID: <4AF0EDDA.7080704@cn.fujitsu.com>
Date: Wed, 04 Nov 2009 10:58:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ftrace: Return EINVAL when writing invalid val to
 set_ftrace_filter
References: <4AEF7F8A.3080300@cn.fujitsu.com> <4AEF7FBC.2050802@cn.fujitsu.com> <20091104014435.GB5092@nowhere>
In-Reply-To: <20091104014435.GB5092@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Nov 03, 2009 at 08:56:28AM +0800, Li Zefan wrote:
>> Currently it doesn't warn user on invald value:
>>
>>  # echo nonexist_symbol > set_ftrace_filter
>>
>> Better make it return failure.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
> 
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> But shouldn't we have the same kind of check from
> ftrace_match_module_records() if we haven't matched
> anything with the regex?
> 

Right, I overlooked it.

