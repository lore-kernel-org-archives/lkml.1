Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXCRMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXCRMOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 08:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXCRMOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 08:14:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4921 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752325AbXCRMON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 08:14:13 -0400
Date: Sun, 18 Mar 2007 12:13:31 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] swsusp: Fix error paths in snapshot_open
Message-ID: <20070318121331.GA4615@ucw.cz>
References: <200703172322.33079.rjw@sisk.pl> <200703172324.35833.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703172324.35833.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We forget to increase device_available if there's an error in snapshot_open(),
> so the snapshot device cannot be open at all after snapshot_open() has returned
> an error.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
