Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZJPGUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZJPGUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 02:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZJPGUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 02:20:03 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35436 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZJPGUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 02:20:02 -0400
Date: Fri, 16 Oct 2009 15:18:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnd Bergmann <arnd@arndb.de>, ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 4/7] sh: Remove BKL from landisk gio
Message-ID: <20091016061818.GC2952@linux-sh.org>
References: <20091015083906.716130653@linutronix.de> <20091015083933.897280001@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015083933.897280001@linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 08:42:33AM -0000, Thomas Gleixner wrote:
> The open function got the BKL via the big push down. Replace it by
> preempt_enable/disable as this is sufficient for an UP machine.
> 
> The ioctl can be unlocked because there is no functionality which
> requires serialization. The usage by multiple callers is broken with
> and without the BKL due to the local static variable addr.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>

Applied to my 2.6.32 queue, thanks Thomas.
