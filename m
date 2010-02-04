Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab0BDQrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:47:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376Ab0BDQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:47:54 -0500
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1002041027070.2470-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002041027070.2470-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 17:46:05 +0100
Message-ID: <1265301965.22001.133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 11:35 -0500, Alan Stern wrote:
> +#include <linux/sched.h>

#include <linux/lockdep.h>

should be sufficient I think.

