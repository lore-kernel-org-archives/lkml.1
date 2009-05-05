Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbZEEXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbZEEXNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZEEXNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:13:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZEEXNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:13:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: compat ioctl32 for /dev/snapshot?
Date: Wed, 6 May 2009 01:13:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <49FEB572.4010909@msgid.tls.msk.ru> <200905051338.46436.arnd@arndb.de> <4A00264C.3020004@msgid.tls.msk.ru>
In-Reply-To: <4A00264C.3020004@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905060113.38289.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009, Michael Tokarev wrote:
> Arnd Bergmann wrote:
> > On Monday 04 May 2009, Rafael J. Wysocki wrote:
> >> In fact I don't think the 32-bit user space will work with 64-bit kernels as is
> >> in this particular case, because of the different pointer size.
> >>
> >> Having a quick look at the code (I don't remember the details right now)
> >> I think most probably it could be modified to handle this case too, but I'm not
> >> really sure.
> > 
> > I don't see anything in the snapshot code that passes pointers to the
> > kernel, so why should the pointer size matter?
> 
> It's the userspace part (uswsusp).  In particular it parses swap
> on-disk data structures.
> 
> But in any case, without compat_ioctl32 in kernel userspace part
> can not be fixed.

Well, agreed. :-)

Rafael
