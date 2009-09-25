Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZIYLly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZIYLly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZIYLlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:41:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:41615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZIYLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:41:53 -0400
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
 get to performance counters
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090925122556.2f8bd939@infradead.org>
References: <20090925122556.2f8bd939@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Sep 2009 13:42:37 +0200
Message-Id: <1253878957.26976.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 12:25 +0200, Arjan van de Ven wrote:
> From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 25 Sep 2009 12:20:57 +0200
> Subject: [PATCH] perf_core: provide a kernel-internal interface to get to performance counters
> 
> There are reasons for kernel code to ask for, and use, performance counters.
> For example, in CPU freq governors this tends to be a good idea, but there
> are other examples possible as well of course.
> 
> This patch adds the needed bits to do enable this functionality; they have been
> tested in an experimental cpufreq driver that I'm working on, and the changes
> are all that I needed to access counters properly.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Looks fine to me, can go in when we acquire a user.


