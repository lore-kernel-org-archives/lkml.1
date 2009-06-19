Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZFSFCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZFSFCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZFSFCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:02:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57106 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZFSFCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:02:08 -0400
Message-ID: <4A3B1C38.5080607@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 13:03:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/filters: remove error messages
References: <4A38AD7F.2070408@cn.fujitsu.com>	 <4A38AD93.4070300@cn.fujitsu.com> <20090617120216.GB6064@nowhere>	 <4A39958C.4010801@cn.fujitsu.com> <1245305452.6207.91.camel@tropicana>
In-Reply-To: <1245305452.6207.91.camel@tropicana>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> On Thu, 2009-06-18 at 09:17 +0800, Li Zefan wrote:
>> Frederic Weisbecker wrote:
>>> On Wed, Jun 17, 2009 at 04:47:15PM +0800, Li Zefan wrote:
>>>> Now we restore original filter is the new one can't be applied,
>>>> and no long show error messages, so we can remove them totally.
>>> Why?
>>> These messages are very powerful to point a user to its mistakes
>>> in filters syntaxes or semantics.
>>>
>>> I really think we are removing a very useful feature in this patch.
>>>
>> I think it's better done by providing a user-space program/script.
>>
>> So what's the criterion to decide what should be in kernel and
>> what should be in user-space?
>>
> 
> I thought there wasn't supposed to be any userspace for non-binary
> tracing.

This is a good point, and I agree on this direction.

> If there is, then yeah, you can get rid of the error messages
> in the kernel because your userspace program can arrange to never submit
> an erroneous filter.
> 

