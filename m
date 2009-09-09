Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZIIOsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZIIOsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIIOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:48:37 -0400
Received: from fifo99.com ([67.223.236.141]:48331 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZIIOsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:48:36 -0400
Subject: Re: [patch for 2.6.31] zaurus c3000 aka spitz: fix resume
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090909075024.GA1400@ucw.cz>
References: <20090909075024.GA1400@ucw.cz>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 07:49:00 -0700
Message-Id: <1252507740.14793.115.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:50 +0200, Pavel Machek wrote:
> Hi, Linus!
> 
> Spitz resume was broken for year or likely two, and it would be very
> nice to fix it for 2.6.31 release. One liner is below, and it really
> can not harm. It already is in Eric's fix queue, so pulling that for
> .31 should work, too.
> 
> Do you think you could take it?

One checkpatch error here..

ERROR: trailing whitespace
#77: FILE: arch/arm/mach-pxa/sharpsl_pm.c:681:
+^Iif ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || $

total: 1 errors, 0 warnings, 10 lines checked


Daniel

