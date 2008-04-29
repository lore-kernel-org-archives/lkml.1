Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbYD2NJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbYD2NJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbYD2NJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:09:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44932 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbYD2NJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:09:03 -0400
Date: Tue, 29 Apr 2008 15:08:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] fix sched_debug livelock
Message-ID: <20080429130852.GA3720@elte.hu>
References: <1209472941.4874.7.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209472941.4874.7.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> (resending, didn't cc lkml)
> 
> Revert debugging commit 7ba2e74ab5a0518bc953042952dd165724bc70c9.  
> print_cfs_rq_tasks() can induce live-lock if a task is dequeued during 
> list traversal.

applied, thanks Mike - good catch!

	Ingo
