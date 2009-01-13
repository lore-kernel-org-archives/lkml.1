Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZAMBie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZAMBie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbZAMBen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:34:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759810AbZAMBem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:34:42 -0500
Message-ID: <496BEF9E.9070405@redhat.com>
Date: Mon, 12 Jan 2009 20:34:22 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ananth@in.ibm.com, jkenisto@us.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Re: [PATCH][bugfix] kprobes: fix module compilation error with CONFIG_KPROBES=n
References: <49628849.1000706@redhat.com>	<4963894B.6000705@redhat.com> <20090112145119.3e556b78.akpm@linux-foundation.org>
In-Reply-To: <20090112145119.3e556b78.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 Jan 2009 11:39:39 -0500
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Masami Hiramatsu wrote:
>>
>>> Define kprobes related data structures even if CONFIG_KPROBES is not set.
>>> This fixes compilation errors which occur if CONFIG_KPROBES is not set, in
>>> kprobe using modules.
>>>
>> Oops, this patch was actually for -mm tree.
>>
> 
> I assume it's needed in mainline now.

Agreed.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

