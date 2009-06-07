Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZFGOHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZFGOHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZFGOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:07:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZFGOHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:07:05 -0400
Message-ID: <4A2BC982.8040207@redhat.com>
Date: Sun, 07 Jun 2009 10:06:58 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] oom: only oom kill exiting tasks with attached
 memory
References: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> When a task is chosen for oom kill and is found to be PF_EXITING,
> __oom_kill_task() is called to elevate the task's timeslice and give it
> access to memory reserves so that it may quickly exit.
> 
> This privilege is unnecessary, however, if the task has already detached
> its mm.  Although its possible for the mm to become detached later since
> task_lock() is not held, __oom_kill_task() will simply be a no-op in such
> circumstances.
> 
> Subsequently, it is no longer necessary to warn about killing mm-less
> tasks since it is a no-op.
> 
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
