Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYJLTN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYJLTN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYJLTNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:13:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbYJLTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:13:19 -0400
Subject: Re: [PATCH 4/4] Implement semaphore latency tracer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: mingo@elte.hu, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1223817124-27239-6-git-send-email-edwintorok@gmail.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
	 <1223817124-27239-6-git-send-email-edwintorok@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 12 Oct 2008 21:13:06 +0200
Message-Id: <1223838786.8634.8.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-12 at 16:12 +0300, Török Edwin wrote:
> Each time a down_read or down_write fails, a unique latency id is generated.
> Later when someone releases the semaphore, it is blamed for the latency of all
> tasks on the wait_list of the semaphore.
> If you would group the output from latency_trace by the latency_id you get all those
> who were contending on a lock, and the tasks that were holding the lock.
> An entry in latency_trace has the format:
> (latency_id) [semaphore_id] read|write
> stacktrace <= stacktrace

What can this tracer do that latencytop cannot already do?


