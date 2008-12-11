Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbYLKRTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbYLKRTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYLKRTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:19:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbYLKRTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:19:38 -0500
Date: Thu, 11 Dec 2008 12:19:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert Richter <robert.richter@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] oprofile: port to the new ring buffer
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
Message-ID: <alpine.DEB.1.10.0812111219100.29200@gandalf.stny.rr.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Dec 2008, Robert Richter wrote:

> This patch set ports cpu buffers in oprofile to the new ring buffer
> provided by the tracing framework. The motivation here is to leave the
> pain of implementing ring buffers to others. Oh, no, there are more
> advantages. Main reason is the support of different sample sizes that
> could be stored in the buffer. Use cases for this are IBS and Cell spu
> profiling. Using the new ring buffer ensures valid and complete
> samples and allows copying the cpu buffer stateless without knowing
> its content. Second it will use generic kernel API and also reduce
> code size. And hopefully, there are less bugs.
> 
> The patch set is also available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git ring_buffer

Robert,

Thanks for doing this! I'll try to take time out this week to review these 
patches.

-- Steve

