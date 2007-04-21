Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXDUIzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXDUIzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXDUIzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:55:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42589 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932247AbXDUIzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:55:38 -0400
Date: Sat, 21 Apr 2007 10:55:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] freezer: Document task_lock in thaw_process
Message-ID: <20070421085528.GA1822@elf.ucw.cz>
References: <200704210023.19825.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704210023.19825.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-04-21 00:23:19, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The task_lock() in include/linux/freezer.h:thaw_process() looks as though it
> were protecting p->flags, which is not the case.  Add a comment that explains
> why it's there.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
