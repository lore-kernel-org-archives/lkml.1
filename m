Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZFHBIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZFHBIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZFHBIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:08:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52160 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZFHBIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:08:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mmotm] oom: only oom kill exiting tasks with attached memory
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
Message-Id: <20090608095659.4360.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Jun 2009 10:08:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

it seems reasonable.
thanks.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



