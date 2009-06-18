Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZFRBPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZFRBPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZFRBP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:15:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58084 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbZFRBP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:15:28 -0400
Message-ID: <4A39958C.4010801@cn.fujitsu.com>
Date: Thu, 18 Jun 2009 09:17:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/filters: remove error messages
References: <4A38AD7F.2070408@cn.fujitsu.com> <4A38AD93.4070300@cn.fujitsu.com> <20090617120216.GB6064@nowhere>
In-Reply-To: <20090617120216.GB6064@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Jun 17, 2009 at 04:47:15PM +0800, Li Zefan wrote:
>> Now we restore original filter is the new one can't be applied,
>> and no long show error messages, so we can remove them totally.
> 
> Why?
> These messages are very powerful to point a user to its mistakes
> in filters syntaxes or semantics.
> 
> I really think we are removing a very useful feature in this patch.
> 

I think it's better done by providing a user-space program/script.

So what's the criterion to decide what should be in kernel and
what should be in user-space?

btw, this feature is not full-fledged, that it can't point to the
exact position where error occured, and the implementation will add
complexity and I'm sure it's worthy or not.

> May be we can keep the previous filter in case of new filter string
> inserting failure, though if the user wanted to insert a new one, there
> are few chances that the previous one is still relevant for him.
> I don't know.
> 
>> Another reason is, I don't think it's good to show error messages
>> when reading a control file.
> 
> So, why not create a filter_error file in this case? One for each
> event and subsys that would print the last error?
> 

Yeah, if we do want to keep this feature in the kernel.
