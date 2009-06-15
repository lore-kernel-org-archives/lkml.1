Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbZFORQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbZFORQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764341AbZFORQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:16:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761318AbZFORQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:16:39 -0400
Date: Mon, 15 Jun 2009 10:16:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Use copy_wait_opts_to_user() in
 wait_task_continued()
Message-Id: <20090615101621.adbf0ec3.akpm@linux-foundation.org>
In-Reply-To: <20090615165536.GC7425@redhat.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
	<1242048349-2766-6-git-send-email-v.mayatskih@gmail.com>
	<20090615165536.GC7425@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 18:55:36 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> I think it is better to drop
> 
> 	wait_task_-cleanups-split-wait_noreap_copyout.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch
> 
> patches, and wait for Vitaly to redo/resend.

OK, done.  Thanks, Oleg.
