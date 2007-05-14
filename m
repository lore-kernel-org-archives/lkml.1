Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXENTOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXENTOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXENTN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:13:58 -0400
Received: from www.osadl.org ([213.239.205.134]:39009 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755156AbXENTN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:13:58 -0400
Subject: Re: [PATCH] timekeeping fix mismerge
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070514115835.19be36d0.akpm@linux-foundation.org>
References: <1179133802.22481.327.camel@localhost.localdomain>
	 <20070514115835.19be36d0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 21:17:23 +0200
Message-Id: <1179170243.7074.13.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 11:58 -0700, Andrew Morton wrote:
> Urgh, that was probably me trying to manage the maelstrom from a million
> monkeys mucking in the same code for multiple months, sigh.
> 
> So what do "broke" and "fix" mean in this context?  What are the
> consequences of this bug, and of its fix?  Is the above appropriate for
> 2.6.21.x and if so why?

clocksource_resume() is not called except from
unregister_time_interpolator(), which is definitely the wrong place.

No 2.6.21.x material, as the move of the timekeeping code happened after
2.6.21.

	tglx


