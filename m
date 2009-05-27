Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZE0AEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZE0AEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760759AbZE0AEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:04:14 -0400
Received: from mail.crca.org.au ([67.207.131.56]:40476 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761425AbZE0AEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:04:14 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905270037.43991.rjw@sisk.pl>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905260002.55500.rjw@sisk.pl> <1243297196.16743.137.camel@nigel-laptop>
	 <200905270037.43991.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 27 May 2009 10:06:03 +1000
Message-Id: <1243382763.13930.112.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2009-05-27 at 00:37 +0200, Rafael J. Wysocki wrote:
> Well, first, our multithreaded I/O is probably not the same thing as you think
> of, because we have an option to use multiple user space threads that process
> image data (compress, encrypt and feed them to the kernel).

Well, I'm using multiple kernel threads, so it's probably not that
different, but okay.

> Now, we found that it only improves performance substantially if both
> compression and encryption are used.
> 
> As far as the numbers are concerned, I don't have the raw hdparm numbers
> handy, but image writing speed with compression alone usually is in the
> 60 MB/s - 100 MB/s range, sometimes more than 100 MB/s, but that really depends
> on the system.  If encryption is added, it drops substantially and multiple
> threads allow us to restore the previous performance (not 100%, but close
> enough to be worth the additional complexity IMO).

Okay. That's still a significant improvement over 20 or 30 MB/s. It
depends, of course, also on the compression ratio that's achieved.

> Still, one should always take the total length of hibernate-resume cycle into
> accout and the image writing/reading time need not be the greatest part of it.

Yes, the total time is what matters. I'm focussing on the I/O speed
because - especially with larger images - it tends to be the biggest
portion.

Regards,

Nigel

