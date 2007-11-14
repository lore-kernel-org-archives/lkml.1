Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbXKNFUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbXKNFUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXKNFUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:20:25 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40649 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXKNFUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:20:24 -0500
Date: Wed, 14 Nov 2007 06:22:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, david@lang.hm,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH revised] enable make ARCH=x86 (and stay backward compatible)
Message-ID: <20071114052201.GA5252@uranus.ravnborg.org>
References: <20071112205451.GA22528@uranus.ravnborg.org> <200711132323.23835.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711132323.23835.elendil@planet.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I've just built v2.6.24-rc2-409-g9418d5d + your patchset for both amd64 and 
> i386 using Debian's kernel-package and both went without problems.

Thanks for testing!

> One (minor) issue. If I start out with a .config for i386, the first make 
> oldconfig will ask to set 64-BIT:
>     64-bit kernel (64BIT) [N/y/?] (NEW)
> It would be nice if that could be avoided somehow.

I do not see this can be avoided.
The typical response is just to accept the default which is N
so we are safe in most cases anyway because default is 'N'.

	Sam
