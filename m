Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbXKARxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbXKARxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXKARxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:53:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbXKARxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:53:21 -0400
Date: Thu, 1 Nov 2007 10:53:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Truxton Fulton <trux@truxton.com>,
       Hiroto Shibuya <hiroto.shibuya@gmail.com>,
       Lee Garrett <lee-in-berlin@web.de>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       ak@suse.de, torvalds@linux-foundation.org
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't
 reboot with kernels > 2.6.13.5 (responsible commit found)
Message-Id: <20071101105304.a46420a7.akpm@linux-foundation.org>
In-Reply-To: <20071101155031.GB8068@cathedrallabs.org>
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org>
	<20070427144434.970de79f.akpm@linux-foundation.org>
	<m2k5vx6vce.fsf@truxton.com>
	<4646171E.7090609@web.de>
	<20070512180240.7a8923d5.akpm@linux-foundation.org>
	<m2sl4tyloc.fsf@truxton.com>
	<20071101155031.GB8068@cathedrallabs.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 11:50:31 -0400 Aristeu Rozanski <aris@ruivo.org> wrote:

> > --- mach_reboot.h       Mon Oct  1 20:24:52 2007
> > +++ mach_reboot.h.new   Tue Oct  2 19:22:13 2007
> > @@ -49,7 +49,7 @@
> >                 udelay(50);
> >                 kb_wait();
> >                 udelay(50);
> > -               outb(cmd | 0x04, 0x60); /* set "System flag" */
> > +               outb(cmd | 0x14, 0x60); /* set "System flag" and "Keyboard Disabled" */
> >                 udelay(50);
> >                 kb_wait();
> >                 udelay(50);
> > 
> > 
> any chance to get this into next -mm?

Is is, as i386-fix-reboot-with-no-keyboard-attached.patch
