Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXCBU3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXCBU3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965574AbXCBU3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:29:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573AbXCBU3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:29:35 -0500
Date: Fri, 2 Mar 2007 12:29:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: 2.6.21-rc2 radeon backlight
Message-Id: <20070302122920.a2967ebf.akpm@linux-foundation.org>
In-Reply-To: <87tzx35zkc.fsf@sycorax.lbl.gov>
References: <87ps7uutsk.fsf@sycorax.lbl.gov>
	<20070301184531.b3aeafe3.akpm@linux-foundation.org>
	<87tzx35zkc.fsf@sycorax.lbl.gov>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 09:24:03 -0800
Alex Romosan <romosan@sycorax.lbl.gov> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Wed, 28 Feb 2007 08:32:43 -0800
> > Alex Romosan <romosan@sycorax.lbl.gov> wrote:
> >
> >> the backlight on my thinkpad still (2.6.20 worked fine) doesn't come
> >> on if i have the radeon backlight enabled. without it, i guess it's
> >> the ibm acpi modules that controls the backlight and it seems to work
> >> fine.
> >> 
> >
> > Unclear. Are you saying that the backlight comes on OK if you use
> > the IBM acpi module?
> 
> yes, if i disable the radeon backlight and use the ibm acpi module,
> than the backlight works. if i enable the radeon backlight, the screen
> stays dark and i can't turn it on (i tried using radeontool to control
> it but nothing happened).

Richard, is this actually a bug, or is it a config error or something like that?

And should we track it as a post-2.6.20 regression?
