Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbYJTC1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbYJTC1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 22:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYJTC1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 22:27:23 -0400
Received: from mail.anarazel.de ([217.115.131.40]:59914 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYJTC1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 22:27:23 -0400
From: Andres Freund <andres@anarazel.de>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 04:27:20 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-04904-gc813b4e; KDE/4.1.2; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie> <200810200358.52147.andres@anarazel.de> <1224469147.5303.47.camel@koto.keithp.com>
In-Reply-To: <1224469147.5303.47.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810200427.21040.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 20 October 2008 04:19:07 you wrote:
> On Mon, 2008-10-20 at 03:58 +0200, Andres Freund wrote:
> > Its basically only this, right?
> > Barring that I have absolutely idea about the code and all related stuff,
> > do I see it correct, that this also will result in problems if the kernel
> > doesn't have the related fix?
> Yes, on this hardware, the kernel is smashing the last few stolen
> entries with a bad value, so running a new driver against an old kernel
> will fail as well. There's not a lot we can do about this direction
> though; until we have all of this hardware management in one place,
> we're stuck trying to synchronize fixes across two code bases.
Ugly situation. So the distribution can't really do anything, because it will 
get locked either way.

> > If its really only a that small portion of hardware... At least the
> > T500/T400 series, containing the same hw as mine, from Lenovo propably is
> > not yet really wide spread (Laptop is 4weeks old or so and wasn't
> > available before).
> I haven't even received my x200s yet as they've just entered production.
> The problem here was that the prototype hardware had a different
> behavior than what is now shipping, so we didn't catch this mistake
> until the first production machines were tested.
Life is fun.

> If you care to try the above fix against your current driver sources,
> that would be helpful for us.
Will do so tomorrow morning, its 4am here ;-) and I finished the work I had to 
do tonight...


Greetings,

Andres
