Return-Path: <linux-kernel-owner+w=401wt.eu-S965253AbXBZMqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbXBZMqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965235AbXBZMqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:46:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45169 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965253AbXBZMqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:46:53 -0500
Date: Mon, 26 Feb 2007 13:45:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 2/3] Freezer: Take kernel_execve into consideration
Message-ID: <20070226124538.GF3386@elf.ucw.cz>
References: <200702261139.59130.rjw@sisk.pl> <200702261149.10579.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702261149.10579.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-02-26 11:49:09, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Kernel threads can become userland processes by calling kernel_execve().  In
> particular, this may happen right after try_to_freeze_tasks(FREEZER_USER_SPACE)
> has returned, so try_to_freeze_tasks() needs to take userspace processes
> into consideration even if it is called with FREEZER_KERNEL_THREADS.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
