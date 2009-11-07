Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZKGTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZKGTF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 14:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZKGTFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 14:05:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41949 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZKGTFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 14:05:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
Date: Sat, 7 Nov 2009 20:06:36 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org
References: <bug-14537-6666@http.bugzilla.kernel.org/> <200911042312.52116.rjw@sisk.pl> <20091107172038.GA1835@ucw.cz>
In-Reply-To: <20091107172038.GA1835@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911072006.36904.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009, Pavel Machek wrote:
> Hi!
> 
> > > > - when trying to suspend:
> > > > ioctl32(s2disk:8164): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12}
> > > > arg(ffc190ec) on /dev/snapshot
> > > > ioctl32(s2disk:8164): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000806)
> > > > on /dev/snapshot
> > > 
> > > snapshot_ioctl seems to lack compat support completely. Raphael ??
> > 
> > It does, but that wouldn't work anyway.  s2disk is one of the things that have
> > to be native.
> 
> Actually... it would be nice to fix that one day, if someone submitted
> nice patch... :-).   

It must be fixed in s2disk first, but that would probably require us to drop
support for older kernels.  Which is not unthinkable, but might hurt some
users.

Thanks,
Rafael
