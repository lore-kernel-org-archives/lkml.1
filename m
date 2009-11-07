Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbZKGUxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbZKGUxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 15:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZKGUxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 15:53:02 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZKGUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 15:52:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
Date: Sat, 7 Nov 2009 21:52:56 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org
References: <bug-14537-6666@http.bugzilla.kernel.org/> <20091107172038.GA1835@ucw.cz> <200911072006.36904.rjw@sisk.pl>
In-Reply-To: <200911072006.36904.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911072152.56586.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+FRDUCJTCJI7RRUfL/rGXwVs+vjqxIg3gIsdD
 fduPsaEhr8gx1FuidWiyynlqrtdlQgR+PZl/fpY5VcC2OItGun
 zq8OAUXKeiRS8iGzQRBvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009, Rafael J. Wysocki wrote:
> > Actually... it would be nice to fix that one day, if someone submitted
> > nice patch... :-).   
> 
> It must be fixed in s2disk first, but that would probably require us to drop
> support for older kernels.  Which is not unthinkable, but might hurt some
> users.

You don't need to drop support for older kernels if s2disk simply tries the
new interface first and falls back to the current one if that fails.

	Arnd <><
