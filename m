Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYIHNkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYIHNkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYIHNkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:40:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:39690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYIHNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:39:59 -0400
Date: Mon, 8 Sep 2008 06:40:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task
 struct
Message-ID: <20080908064002.7abc2a22@infradead.org>
In-Reply-To: <20080908132713.GA18486@elf.ucw.cz>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161423.59ebf2fc@infradead.org>
	<20080902100439.GA11383@elf.ucw.cz>
	<20080902060323.70245b83@infradead.org>
	<20080908132713.GA18486@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 15:27:16 +0200
Pavel Machek <pavel@suse.cz> wrote:
> > 
> > ... which nobody uses today.
> > It's not just new syscalls, it's a new glibc api as well at that
> > point.
> 
> ...and new applications, yes. I believe applications should
> explicitely enable slacking timers.

timers are slacking today, at least for select() and poll(), and are a
great deal more so than the defaults in this patchkit.

The great advantage of the prctl() approach (which is usable) over new
system calls and glibc APIs is that it will get used, because the admin
can use it just like he uses the "nice" command, on existing software.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
