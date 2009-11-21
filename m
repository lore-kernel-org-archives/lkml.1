Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZKUMFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZKUMFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 07:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZKUMFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 07:05:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:39442 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZKUMFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 07:05:31 -0500
Subject: Re: [PATCH 06/19] scheduler: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
In-Reply-To: <1258692407-8985-7-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	 <1258692407-8985-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Nov 2009 13:04:43 +0100
Message-ID: <1258805083.4104.918.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 13:46 +0900, Tejun Heo wrote:
> Implement force_cpus_allowed() which is similar to
> set_cpus_allowed_ptr() but bypasses PF_THREAD_BOUND check and ignores
> cpu_active() status as long as the target cpu is online.  This will be
> used for concurrency-managed workqueue.

This is a very unsatisfactory changelog and after staring at the patch
for a few minutes I still go WTF?!

