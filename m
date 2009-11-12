Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZKLTRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZKLTRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZKLTRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:17:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:57215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZKLTRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:17:35 -0500
Message-ID: <4AFC5F2E.9040709@kernel.org>
Date: Fri, 13 Nov 2009 04:17:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <20091111171703.GA28506@redhat.com> <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/13/2009 02:33 AM, Thomas Gleixner wrote:
> Subject: workqueue: Add debugobjects support
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 12 Nov 2009 16:25:34 +0100
> 
> Add debugobject support to track the life time of work_structs.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

This looks great.  I'm about to create a wq tree for concurrency
managed workqueue patches.  Do you mind if I route this patch through
there?

Thanks.

-- 
tejun
