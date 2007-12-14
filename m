Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXLNTHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXLNTHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXLNTHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:07:31 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:41198 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXLNTHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:07:30 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 20:05:20 +0100
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <20071213003028.676998182@mvista.com> <200712141922.04677.mb@bu3sch.de> <2c0942db0712141045nf7bf730l677936614f7db736@mail.gmail.com>
In-Reply-To: <2c0942db0712141045nf7bf730l677936614f7db736@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712142005.21375.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 19:45:02 Ray Lee wrote:
> > > One problem related to b43 source code, patch exists, has yet to be
> > > merged upstream.
> >
> > Yeah. A problem preventing a LED from blinking.
> > That's a real regression.... Come on. Stop that bullshit.
> 
> I'm going to say this one last time. If rfkill and rfkill-input aren't
> manually loaded before sb and b43, not one damn thing comes out in
> dmesg. Nothing. Nada. Zilch. Zero. Bupkis. Zot. Null. The only way to
> find out that those modules had to be loaded by hand was to go read
> the bcm43xx-dev archives. Once those were loaded, messages came out in
> dmesg pointing me to the URL for updated firmware.

I'm sorry. The patch that _you_ quoted fixes a blinking LED
and nothing else. It does _not_ fix loading of rfkill or b43 in any way.
It does, however, fix loading of rfkill-input. But the b43 module
operation does _not_ depend in any way on the rfkill-input module, except
the tiny LED that doesn't blink if it's not loaded.
I hope you understood now that the thread on bcm43xx-dev was NOT about
your requirement to load rfkill before b43.

> I have complete current userspace as of yesterday's Ubuntu Hardy Heron
> development archives.

Ok. I will install a copy of Ubuntu Hardy Heron and check if I can
reproduce this.
However the fact that this does not happen on older Ubuntu platforms
and does not happen on Fedora leads to the conclusion that it
is a bug in Hardy Heron that I am not responsible for.

And you also do realise that Hardy Heron is the current development
version of Ubuntu? Development versions have bugs.

> One last thing. I've been nice to you. Please be nice to me.

If you simply stop blaming bugs on me that I am not responsible for
at all, that is a deal. What about filing a bug at the ubuntu bugzilla?

PS:
Note that Ubuntu is known to break the broadcom driver every now and then.
But I can not change that.

-- 
Greetings Michael.
