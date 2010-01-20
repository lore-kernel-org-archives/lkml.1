Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349Ab0ATNnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0ATNnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478Ab0ATNnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:43:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:46590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0ATNnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:43:12 -0500
Subject: Re: [PATCH] perf tools: fix write_event()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B570657.5090105@cn.fujitsu.com>
References: <4B570657.5090105@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:41:41 +0100
Message-ID: <1263994901.4283.1060.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 21:34 +0800, Xiao Guangrong wrote:
> We parse the event while it's read from mmap buffer in
> write_event(), but sometimes the event will straddles the
> mmap boundary, we should handle this case
> 
> And if we record events(such as perf kmem/sched) for long
> times, Ctrl + C can't interrupt it just for this reason

Uhm, how why? it didn't used to know about events and just copied the
data.

