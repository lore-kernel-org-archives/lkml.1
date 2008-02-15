Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbYBOJ4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbYBOJ4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYBOJz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:55:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4364 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757249AbYBOJz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:55:57 -0500
Date: Fri, 15 Feb 2008 09:55:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, hpa@zytor.com,
       rjw@sisk.pl, sam@ravnborg.org
Subject: Re: [patch] move wakeup code to .c
Message-ID: <20080215095544.GA4667@ucw.cz>
References: <20080210222723.GA1865@elf.ucw.cz> <200802150135.07127.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802150135.07127.lenb@kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> scripts/checkpatch.pl
> ERROR: do not initialise externals to 0 or NULL
> #113: FILE: arch/x86/boot/video-mode.c:29:
> +int do_restore = 0;    /* Screen contents changed during mode flip */

We were doing file move with minimal changes.

> ERROR: need a space before the open parenthesis '('
> #710: FILE: arch/x86/kernel/acpi/realmode/wakemain.c:70:
> +               while(1);

Bogus warning.

I'll fix al but this one, but could we do it as a followup patch? I'm
currently at holidays, moving .S code into .c is rather
good/important, and it should get testing ASAP.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
