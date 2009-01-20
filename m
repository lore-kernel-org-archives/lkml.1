Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbZATOZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbZATOZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZATOZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:25:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:2501 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZATOZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:25:24 -0500
From: Vitaliy Gusev <vgusev@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] kthread: Don't looking for a task in create_kthread() #2
Date: Tue, 20 Jan 2009 17:16:34 +0300
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
References: <200901201345.42054.vgusev@openvz.org> <20090120120642.GA9497@redhat.com>
In-Reply-To: <20090120120642.GA9497@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901201716.34842.vgusev@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2009 15:06:42 Oleg Nesterov wrote:
> On 01/20, Vitaliy Gusev wrote:
> >
> > Remove the unnecessary find_task_by_pid_ns(). kthread() can just
> > use "current" to get the same result.
> 
> I think the patch is nice and correct.
> 
> 
> 
> BTW. Perhaps it also makes sense to move sched_setscheduler/etc code
> from create_kthread() to kthread_create(), what do you think?

I don't thinks so. create_kthread() is executed in kthreadd process and 
sched_setscheduler/etc preparation things are reflected to kthreadd's CPU usage.
In other words it is a kthreadd matter, start and setup a thread.

> 
> (of course, this needs another patch)
> 
> Oleg.
> 
> 



-- 
Thank,
Vitaliy Gusev
