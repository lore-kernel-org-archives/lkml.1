Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbZFPXEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbZFPXEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZFPXEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:04:40 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54738 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560AbZFPXEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:04:40 -0400
Date: Wed, 17 Jun 2009 04:34:28 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: =?iso-8859-1?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch 0/2] ksym_tracer:ksym tracer fixes
Message-ID: <20090616230428.GA14753@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,
	Please find a set of patches that fix two separate issues found in
the ksym tracer.

Summary of patchset
--------------------
1: An early return before a line-return in the output function causes the
output to be concatenated. This is fixed using an unconditional line return.
2: Symbol unregistration results in missing information and partial output,
which causes problems for 'trace_pipe' functionality. The patch adds an early
check to detect missing fields and return with a TRACE_TYPE_HANDLED code to
eliminate trace belonging to stale ksym tracer symbols.

Let me know your comments on this patchset. If found acceptable, kindly patch
them to the ksym tracer plugin in -tip tree.

Thanks,
K.Prasad

