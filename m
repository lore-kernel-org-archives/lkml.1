Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZEYW3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZEYW3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZEYW3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:29:00 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55533 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZEYW27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:28:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: nigel@tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Tue, 26 May 2009 00:29:24 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090525123228.GA13446@elf.ucw.cz> <1243287557.16743.114.camel@nigel-laptop>
In-Reply-To: <1243287557.16743.114.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260029.25847.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 25. Mai 2009 23:39:17 schrieb Nigel Cunningham:
> > If there's not enough swap available, swsusp should freeze, realize
> > there's no swap, unfreeze and continue. I do not see reliability
> > problem there.
>
> If there's not enough storage available (I'm also thinking of the file
> allocator Oliver wants), freeing some memory may get you in a position

No, I do want a dedicated partition. Going to a filesystem is just hiding
the problem. Filesystems can return -ENOSPC.
I also want my sytem to reliably hibernate if the filesystem to hold
the image happens to be remounted ro or to be undergoing a filesystem
check.

For full reliability you simply need a reservation. In addition that's
the fastest solution, too. A simple linear write to an unfragmented
area.
The typical system today has three orders of magnitude more disk
than ram. Do you really have a sytem you want to hibernate that has
less than 2two orders of magnitude more disk than ram?

	Regards
		Oliver

