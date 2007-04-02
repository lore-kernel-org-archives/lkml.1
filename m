Return-Path: <linux-kernel-owner+w=401wt.eu-S966011AbXDBW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbXDBW6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966010AbXDBW6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:58:41 -0400
Received: from www.osadl.org ([213.239.205.134]:47977 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966011AbXDBW6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:58:40 -0400
Subject: Re: [patch 6/13] signal/timer/event fds v10 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.10599.1175553994.6>
References: <send-serie.davidel@xmailserver.org.10599.1175553994.6>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 00:58:49 +0200
Message-Id: <1175554729.28263.196.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 15:46 -0700, Davide Libenzi wrote:
> +
> +#include <linux/file.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/mount.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/signal.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/time.h>
> +#include <linux/hrtimer.h>
> +#include <linux/jiffies.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/timerfd.h>

Can you bring them into alphabetic order and check if the whole bunch is
really required ?

Otherwise it looks good !

	tglx


