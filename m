Return-Path: <linux-kernel-owner+w=401wt.eu-S934609AbYEVJrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbYEVJrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYEVJq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:46:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7388 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYEVJq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:46:58 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [PATCH 2/5] ftrace: remove wakeup functions from sched_switch
	tracer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, pq@iki.fi,
       proski@gnu.org, sandmann@redhat.com,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080522042301.782160037@goodmis.org>
References: <20080522042215.584408893@goodmis.org>
	 <20080522042301.782160037@goodmis.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 11:46:40 +0200
Message-Id: <1211449600.29104.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 00:22 -0400, Steven Rostedt wrote:
> plain text document attachment (ftrace-remove-wakeup-from-sched.patch)
> The added wakeup functions inside the sched_switch tracer dirty the trace
> quite a bit. The sched_switch tracer is used to watch context switches.
> Adding wakeups to this make the flow of this trace much more complex to
> understand.
> 
> Perhaps we can add a way to turn on or off this tracing but for now I'm
> reverting the sched_switch back to its original behavior.

Not liking this - this is very useful.

use grep already.

