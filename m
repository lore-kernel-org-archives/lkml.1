Return-Path: <linux-kernel-owner+w=401wt.eu-S1161633AbXDXFt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161633AbXDXFt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161637AbXDXFt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:49:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35344 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161633AbXDXFt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:49:58 -0400
Date: Mon, 23 Apr 2007 22:49:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: kill all threads that share mm with killed task
In-Reply-To: <Pine.LNX.4.64.0704232134430.11399@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0704232242580.5109@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704232134430.11399@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, David Rientjes wrote:

> oom_kill_task() calls __oom_kill_task() to OOM kill a selected task.
> When finding other threads that share an mm with that task, we need to
> kill those individual threads and not the same one.

Obvious fix. It was broken by
 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f2a2a7108aa0039ba7a5fe7a0d2ecef2219a7584
Dec 7. So its in 2.6.20 and later. Candiate for stable?

