Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbZATMJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbZATMJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZATMI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:08:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbZATMI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:08:56 -0500
Date: Tue, 20 Jan 2009 13:06:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaliy Gusev <vgusev@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] kthread: Don't looking for a task in create_kthread()
	#2
Message-ID: <20090120120642.GA9497@redhat.com>
References: <200901201345.42054.vgusev@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901201345.42054.vgusev@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Vitaliy Gusev wrote:
>
> Remove the unnecessary find_task_by_pid_ns(). kthread() can just
> use "current" to get the same result.

I think the patch is nice and correct.



BTW. Perhaps it also makes sense to move sched_setscheduler/etc code
from create_kthread() to kthread_create(), what do you think?

(of course, this needs another patch)

Oleg.

