Return-Path: <linux-kernel-owner+w=401wt.eu-S1764383AbXLQWsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764383AbXLQWsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbXLQWsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:48:16 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:33169 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbXLQWsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:48:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: mvtodevnull@gmail.com
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Mon, 17 Dec 2007 23:45:19 +0100
User-Agent: KMail/1.9.6
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Daniel Walker" <dwalker@mvista.com>,
       "Ray Lee" <ray-lk@madrabbit.org>,
       "Simon Holm =?iso-8859-1?q?Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <520b60a90712170235p4c0bc0f5ybf64da0853f06d6@mail.gmail.com> <520b60a90712171404v647d3d62h69e61d223040779b@mail.gmail.com>
In-Reply-To: <520b60a90712171404v647d3d62h69e61d223040779b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712172345.20710.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 December 2007 23:04:37 mvtodevnull@gmail.com wrote:
> On Dec 17, 2007 5:35 AM,  <mvtodevnull@gmail.com> wrote:
> > If this is a mac80211 related problem, then other systems connecting
> > to the same ap and using mac80211 would also be affected? Like I said
> > earlier, there are five machines connecting to this ap, and I just
> > realized one of them has a ralink card that uses the rt2x00 driver,
> > which I believe is mac80211. That system doesn't have this problem,
> > which leads me to believe it may not be mac80211 after all, although I
> > wouldn't rule it out.
> >
> 
> This also doesn't seem to be related to firmware version. I forced my
> device to use b43legacy, and the results were identical with the
> version 3 firmware.

Ehm, excuse me.
What are you doing exactly? In this thread you told me you have
a device which requires b43:

> I don't know what happened before, but after a reboot, I can't repeat
> the 200 kB/s speed. It's back down to 40 kB/s, just like originally. I
> didn't move the laptop, or the ap, the only thing I can think of that
> might have changed is the noise level. FWIW, link quality is
> consistently the same or better with b43.

How the hell can you now "force it to use b43legacy"??

-- 
Greetings Michael.
