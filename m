Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYKPKqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYKPKqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKPKqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:46:16 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37627 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYKPKqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:46:16 -0500
Date: Sun, 16 Nov 2008 16:16:04 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix writing to trace/trace_options
Message-ID: <20081116104604.GA25788@skywalker>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 04:07:58PM +0530, Aneesh Kumar K.V wrote:
> writing to trace/trace_options use the index of the array
> to find the value of the flag. With branch tracer flag
> defined conditionally, this breaks writing to trace_options
> with branch tracer disabled.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

tg export didn't add numbering to the patch based on dependency.
So the series is in the below order

[PATCH] ftrace: add proper bin iterator support
[PATCH] ftrace: Add dump iteator
[PATCH] ftrace: Add debug_print trace to print data from kernel to userspace
[PATCH] ftrace: Add new entry type TRACE_BIN_DUMP
[PATCH] ftrace: Add debug_dump trace to dump binary data from kernel to userspace
[PATCH] Fix writing to trace/trace_options

The patches are against -tip with HEAD
7195b6707adcd00f413ce07e6b9954b4c597495c

-aneesh
