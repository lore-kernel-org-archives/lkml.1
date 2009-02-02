Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZBBOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZBBOtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZBBOtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:49:09 -0500
Received: from fifo99.com ([67.223.236.141]:59632 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZBBOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:49:08 -0500
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: Daniel Walker <dwalker@fifo99.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090127001708.GA4815@nowhere>
References: <20090127001708.GA4815@nowhere>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 06:49:00 -0800
Message-Id: <1233586140.5903.95.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 01:17 +0100, Frederic Weisbecker wrote:

> All of the workqueues with 0 work inserted do nothing. 
> For several reasons:
> 
> _ Unneeded built drivers for my system that create workqueue(s) when they init
> _ Services which need their own workqueue, for several reasons, but who receive
>   very rare jobs (often never)
> _ ...?
> 

Some of the workqueues you have on your system can be removed just by
tuning your kernel config. It's more desirable to be able to remove the
whole unused feature since that's all unused memory beyond just
thread .. 

Daniel

