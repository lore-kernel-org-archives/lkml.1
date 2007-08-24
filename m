Return-Path: <linux-kernel-owner+w=401wt.eu-S964836AbXHYKRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836AbXHYKRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 06:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763007AbXHYKRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 06:17:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4927 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760124AbXHYKRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 06:17:08 -0400
Date: Fri, 24 Aug 2007 20:46:33 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on x86_64
Message-ID: <20070824204632.GA5008@ucw.cz>
References: <200708241206.57178.rjw@sisk.pl> <200708241211.55319.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708241211.55319.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make it possible to restore a hibernation image on x86_64 with the help of a
> kernel different from the one in the image.
> 
> The idea is to split the core restoration code into two separate parts and to
> place each of them in a different page.  The first part belongs to the boot

What happens in case where both parts want to be
at the same place? (Like kernel being restored is 4KB smaller, so that
routines now collide?)
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
