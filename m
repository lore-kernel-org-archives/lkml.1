Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZKGRUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZKGRUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 12:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZKGRUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 12:20:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33120 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZKGRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 12:20:40 -0500
Date: Sat, 7 Nov 2009 18:20:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
Message-ID: <20091107172038.GA1835@ucw.cz>
References: <bug-14537-6666@http.bugzilla.kernel.org/> <alpine.LFD.2.00.0911041142370.12138@localhost.localdomain> <200911042312.52116.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911042312.52116.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > - when trying to suspend:
> > > ioctl32(s2disk:8164): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12}
> > > arg(ffc190ec) on /dev/snapshot
> > > ioctl32(s2disk:8164): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000806)
> > > on /dev/snapshot
> > 
> > snapshot_ioctl seems to lack compat support completely. Raphael ??
> 
> It does, but that wouldn't work anyway.  s2disk is one of the things that have
> to be native.

Actually... it would be nice to fix that one day, if someone submitted
nice patch... :-).   
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
