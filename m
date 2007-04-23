Return-Path: <linux-kernel-owner+w=401wt.eu-S1161293AbXDWKlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161293AbXDWKlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161263AbXDWKlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:41:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56712 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161323AbXDWKlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:41:20 -0400
Date: Mon, 23 Apr 2007 12:41:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com
Subject: Re: [RFC][PATCH -mm 1/3] Separate freezer from PM code
Message-ID: <20070423104111.GC5635@elf.ucw.cz>
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu> <200704222128.49419.rjw@sisk.pl> <200704222133.38400.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222133.38400.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Now that the freezer is used by kprobes, it is no longer a PM-specific piece of
> code.  Move the freezer code out of kernel/power and introduce the
> CONFIG_FREEZER option that will be chosen automatically if PM or KPROBES is set.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
