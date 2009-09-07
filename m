Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZIGSiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZIGSiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZIGSiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:38:22 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:40081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbZIGSiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:38:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig CROSS_COMPILE option
In-Reply-To: Pavel Machek's message of  Monday, 7 September 2009 15:09:04 +0200 <20090907130402.GB1595@ucw.cz>
References: <20090905002947.A4C678BEB1@magilla.sf.frob.com>
	<20090907130402.GB1595@ucw.cz>
X-Windows: the first fully modular software disaster.
Message-Id: <20090907183801.379228BF3F@magilla.sf.frob.com>
Date: Mon,  7 Sep 2009 11:38:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes that would be very nice. Editing Makefile every time I
> crosscomppile for arm sucks.

The other trick I can recommend is to write a GNUmakefile containing:

ARCH=foo
CROSS_COMPILE=foo-linux-
include Makefile

(GNU make reads GNUmakefile in preference to Makefile.)
But this manual hackery is still not nearly as nice as the automagic way.

> But... do we need an option for subarch, too? And will Kconfig system
> handle that?

I'm not sure I follow exactly what your concern is.  I am mostly familiar
with doing x86 and powerpc builds.  For both of those, the kernel config
sets whether it's the 32-bit or 64-bit world.


Thanks,
Roland
