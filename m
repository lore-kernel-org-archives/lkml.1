Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZA3XYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZA3XYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZA3XYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:24:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbZA3XYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:24:13 -0500
Date: Fri, 30 Jan 2009 15:23:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan Opmeer <arjan@opmeer.net>
Cc: apw@canonical.com, patrakov@gmail.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: elantech touchpad driver miss-recognising logitech mice
Message-Id: <20090130152330.4ff2cbb2.akpm@linux-foundation.org>
In-Reply-To: <20090126162303.GA11618@adopmeer.homeip.net>
References: <20090126150821.GC31179@shadowen.org>
	<20090126162303.GA11618@adopmeer.homeip.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 17:23:03 +0100
Arjan Opmeer <arjan@opmeer.net> wrote:

> 
> On Mon, Jan 26, 2009 at 03:08:21PM +0000, Andy Whitcroft wrote:
> > 
> > Failing that I did build a modified patch (below) based on that from the
> > thread plus the suggested improvements.  This has been tested by people
> > with the Logitech mice successfully, and also by people with elantech
> > touchpads who report no regressions.
> 
> Good! This means the suggested fix is working :)
> 
> However, my original proposal:
> 
>    http://patchwork.kernel.org/patch/595/
> 
> also removed printing the version query result in elantech_init() to keep
> the amount of log messages the same.
> 
> > If there is no later patches then perhaps you could test this one, and
> > then I can push it upstream.
> 
> Dmitry suggested moving the Elantech detection down in psmouse_extensions()
> in psmouse-base.c to make the mouse detection less chatty:
> 
>    http://lkml.org/lkml/2009/1/20/55
> 
> However, Alexander pointed out he did not move it far enough down:
> 
>    http://lkml.org/lkml/2009/1/22/18
> 
> It should have been moved all the way down below the call to
> im_explorer_detect() for him to not see the extra Elantech detection noise.
> 
> Now, it is Dmitry's call again to determine whether he really wants to move
> the call to elantech_detect() that far down or can live with the extra log
> messages... :)
> 

blah.  Please propose a final patch for me to stash away, lest the
issue get forgotten about.

