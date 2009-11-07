Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbZKGVNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbZKGVNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZKGVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:13:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZKGVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:13:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
Date: Sat, 7 Nov 2009 22:12:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org
References: <bug-14537-6666@http.bugzilla.kernel.org/> <200911072152.56586.arnd@arndb.de> <200911072210.55270.rjw@sisk.pl>
In-Reply-To: <200911072210.55270.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911072212.57645.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19sv72sZf5AhgCToseZohelXxU51Ip//pJiQXy
 yMp50cxUJEUoHla2Up3jDkcKCF9GZy6GEPpimZLdlSCGUBQqdW
 f/cGC43dS3LX3A54eOeiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009, Rafael J. Wysocki wrote:
> On Saturday 07 November 2009, Arnd Bergmann wrote:
> > On Saturday 07 November 2009, Rafael J. Wysocki wrote:
> > > > Actually... it would be nice to fix that one day, if someone submitted
> > > > nice patch... :-).   
> > > 
> > > It must be fixed in s2disk first, but that would probably require us to drop
> > > support for older kernels.  Which is not unthinkable, but might hurt some
> > > users.
> > 
> > You don't need to drop support for older kernels if s2disk simply tries the
> > new interface first and falls back to the current one if that fails.
> 
> Compat ioctls support is not possible with the old interface.

Right, but that doesn't imply dropping support for something that is
working right now. The interesting case is people upgrading the user
space or the kernel without breaking stuff.

	Arnd <><
