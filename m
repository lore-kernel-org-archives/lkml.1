Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYKPPHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYKPPHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYKPPHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:07:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYKPPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:07:41 -0500
Date: Sun, 16 Nov 2008 10:07:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: mingo@elte.hu, akpm@linux-foundation.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix writing to trace/trace_options
In-Reply-To: <20081116104604.GA25788@skywalker>
Message-ID: <alpine.DEB.1.10.0811161007200.2919@gandalf.stny.rr.com>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081116104604.GA25788@skywalker>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Nov 2008, Aneesh Kumar K.V wrote:

> On Sun, Nov 16, 2008 at 04:07:58PM +0530, Aneesh Kumar K.V wrote:
> > writing to trace/trace_options use the index of the array
> > to find the value of the flag. With branch tracer flag
> > defined conditionally, this breaks writing to trace_options
> > with branch tracer disabled.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> tg export didn't add numbering to the patch based on dependency.
> So the series is in the below order
> 
> [PATCH] ftrace: add proper bin iterator support
> [PATCH] ftrace: Add dump iteator
> [PATCH] ftrace: Add debug_print trace to print data from kernel to userspace
> [PATCH] ftrace: Add new entry type TRACE_BIN_DUMP
> [PATCH] ftrace: Add debug_dump trace to dump binary data from kernel to userspace
> [PATCH] Fix writing to trace/trace_options
> 
> The patches are against -tip with HEAD
> 7195b6707adcd00f413ce07e6b9954b4c597495c

Thanks Aneesh,

I'll look closer at these patches on Monday.

-- Steve

