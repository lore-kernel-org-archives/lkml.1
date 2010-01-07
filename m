Return-Path: <linux-kernel-owner+w=401wt.eu-S932904Ab0AGBDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab0AGBDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800Ab0AGBDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:03:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56931 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932736Ab0AGBDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:03:33 -0500
Message-ID: <4B453280.7040800@cn.fujitsu.com>
Date: Thu, 07 Jan 2010 09:01:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] trace_syscalls: cleanup for syscalls_metadata
References: <4B448499.6080609@cn.fujitsu.com> <1262797070.28171.2972.camel@gandalf.stny.rr.com>
In-Reply-To: <1262797070.28171.2972.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2010-01-06 at 20:39 +0800, Lai Jiangshan wrote:
>> NR_syscalls is compile-time constant.
> 
> The question is, is that always true on all archs, and will that always
> be true?
> 
> Unless we can guarantee somewhere that NR_syscalls must be constant on
> all archs, we can't make this change. If it is guaranteed, then sure,
> this patch is fine.
> 

It seems that there is no spec/document guarantees it.

I searched all NR_syscalls in current kernel source code,
and I found it is a constant in header file (all archs).

trace_syscalls.c has already used it as a compile-time constant:

static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);

Thanks, Lai
