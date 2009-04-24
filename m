Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZDXULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZDXULW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZDXULO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:11:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbZDXULN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:11:13 -0400
Date: Fri, 24 Apr 2009 13:06:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org,
       oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
Message-Id: <20090424130616.a3c217cb.akpm@linux-foundation.org>
In-Reply-To: <49F1A59B.3080206@cn.fujitsu.com>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
	<20090415011533.GI5968@nowhere>
	<20090415141250.AC46.A69D9226@jp.fujitsu.com>
	<49E8282A.6010004@cn.fujitsu.com>
	<49E82CA7.2040606@cn.fujitsu.com>
	<20090417134557.GA23493@elte.hu>
	<49F1A59B.3080206@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 19:42:19 +0800
Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> These patchs add tracepoints for per-worklet tracing.
> Now we have enough tracepoints to start makeing trace_workqueue.c support
> worklet time mesurement.

I'm not seing anywhere in this patchset a description of the user
interface.  What does the operator/programmer actually get to see from
the kernel as a result of these changes?

A complete usage example would be an appropriate way of communicating
all of this.

The patches introduce a moderate amount of tracing-specific hooks into
the core workqueue code, which inevitably increases the maintenance
load for that code.  It is important that it be demonstrated that the
benefts of the code are worth that cost.  Hence it is important that
these benefits be demonstrated to us, by yourself.  Please.

Another way of looking at it: which previously-encountered problems
would this facility have helped us to solve?  How will this facility
help us to solve problems in the future?  Looking at this patch series
I cannot answer those questions!


