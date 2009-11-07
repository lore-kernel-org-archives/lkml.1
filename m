Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZKGVJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZKGVJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZKGVJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:09:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZKGVJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:09:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
Date: Sat, 7 Nov 2009 22:10:55 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-tst; KDE/4.3.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org
References: <bug-14537-6666@http.bugzilla.kernel.org/> <200911072006.36904.rjw@sisk.pl> <200911072152.56586.arnd@arndb.de>
In-Reply-To: <200911072152.56586.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911072210.55270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009, Arnd Bergmann wrote:
> On Saturday 07 November 2009, Rafael J. Wysocki wrote:
> > > Actually... it would be nice to fix that one day, if someone submitted
> > > nice patch... :-).   
> > 
> > It must be fixed in s2disk first, but that would probably require us to drop
> > support for older kernels.  Which is not unthinkable, but might hurt some
> > users.
> 
> You don't need to drop support for older kernels if s2disk simply tries the
> new interface first and falls back to the current one if that fails.

Compat ioctls support is not possible with the old interface.

Thanks,
Rafael
