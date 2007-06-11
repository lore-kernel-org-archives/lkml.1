Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXFKVgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXFKVgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXFKVgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:36:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57113 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082AbXFKVga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:36:30 -0400
Date: Mon, 11 Jun 2007 23:36:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Fix userland interface
Message-ID: <20070611213622.GC3917@elf.ucw.cz>
References: <200706111652.01994.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706111652.01994.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [2.6.22 candidate, IMHO]

It is trivial enough that it can go there, yes. But it is not a
regression neither it is particulary serious.

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix oops caused by 'cat /dev/snapshot', reported by Arkadiusz Miskiewicz, and
> make it impossible to thaw tasks with the help of the swsusp userland interface
> while there is a snapshot image ready to save.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK. 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
