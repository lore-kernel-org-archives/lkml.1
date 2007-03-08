Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXCHFus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXCHFus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932262AbXCHFus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:50:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbXCHFur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:50:47 -0500
Date: Wed, 7 Mar 2007 21:47:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: auxsvr@gmail.com
Cc: linux-kernel@vger.kernel.org, Sid Boyce <g3vbv@blueyonder.co.uk>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Message-Id: <20070307214730.87859590.akpm@linux-foundation.org>
In-Reply-To: <200702281805.13822.auxsvr@gmail.com>
References: <45E59D64.3070202@blueyonder.co.uk>
	<200702281805.13822.auxsvr@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc restored.  Please always do reply-to-all)

> On Wed, 28 Feb 2007 18:05:13 +0200 auxsvr@gmail.com wrote:
> On Wednesday 28 February 2007 17:19, Sid Boyce wrote:
> > openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup not to
> > require a password to unlock, but it asks for password. When the screen
> > unlocks, kwin is gone with no errors logged in /var/log/kdm or
> > /var/log/messages. No problems with 2.6.20.
> >
> > Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2.
> > Regards
> > Sid.
> 
> This is the linux kernel mailing list. Perhaps you should post your problem to 
> the opensuse mailing list.

2.6.20 worked.

2.6.20-rc2 did not.

Working theory: the kernel broke.

Sid, the chances that anyone can work out what caused this are pretty low. 
It would be great if you could perform a git bisection search sometime in
the next few weeks, work out which commit caused this.

Thanks.

