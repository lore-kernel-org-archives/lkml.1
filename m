Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbXCEViB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbXCEViB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbXCEViA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:38:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4527 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933603AbXCEVh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:37:59 -0500
Date: Tue, 1 Jan 2002 04:57:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>, malattia@linux.it
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21 - part II (resend)
Message-ID: <20020101045751.GD4106@ucw.cz>
References: <200702162223.59837.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702162223.59837.lenb@kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> commit 4465857d5f99079bae00621626adf74ed8256296
> Author: Mattia Dongili <malattia@linux.it>
> Date:   Sat Jan 13 23:04:39 2007 +0100
> 
>     sony_acpi: Add lanpower and audiopower controls
>     
>     audiopower works well on my SZ72B so it's not marked has "debug" while lanpower
>     has at least one report of not resuming power happily so morked as "debug"
>     
>     Signed-off-by: Mattia Dongili <malattia@linux.it>
>     Signed-off-by: Len Brown <len.brown@intel.com>

What is interface to these? It would be nice to automagically disable
audiopower when sound device is closed, and automagically power down
lan on ifconfig ... down.

(Sorry for time machine)
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
