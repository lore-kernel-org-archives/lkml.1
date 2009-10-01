Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbZJAOvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbZJAOvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbZJAOvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:51:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932666AbZJAOvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:51:35 -0400
Date: Thu, 1 Oct 2009 07:49:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed
 workqueue
Message-Id: <20091001074959.dbdf6f6a.akpm@linux-foundation.org>
In-Reply-To: <1254384558-1018-20-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
	<1254384558-1018-20-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Oct 2009 17:09:18 +0900 Tejun Heo <tj@kernel.org> wrote:

> To solve the above issues, this patch implements concurrency-managed
> workqueue.

Seems reasonable.

This approach would appear to rule out the option of setting a work
thread's state (scheduling policy, scheduling priority, uid, etc) to
anything other than some default.

I guess that's unlikely to be a problem if we haven't yet had a need to
do that, but I'd be a bit surprised to discover that nobody has done
that sort of thing yet?  Nobody has niced up their workqueue threads?

