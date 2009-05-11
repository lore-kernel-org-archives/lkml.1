Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbZEKV2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbZEKV2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbZEKV2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:28:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759921AbZEKV2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:28:20 -0400
Date: Mon, 11 May 2009 14:22:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.ziljstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/11 -mmotm] oom: prevent possible OOM_DISABLE livelock
Message-Id: <20090511142234.0648b43b.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905101501470.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0905101501470.18804@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 15:07:19 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:
>

The changelog perplexes me.

> This moves the check for OOM_DISABLE to the badness heuristic while
> holding task_lock().

why?

>  Badness scores of 0 are now explicitly prohibited
> from being oom killed

why?

> and since the oom_adj value is a characteristic of
> an mm and not a task, it is no longer necessary to check the oom_adj
> value for threads sharing the same memory (except when simply issuing
> SIGKILLs for threads in other thread groups).

ok...


The title says that this patch fixes a livelock.  But the changelog
didn't describe that livelock and didn't tell us how the patch fixed
it.
