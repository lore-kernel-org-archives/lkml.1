Return-Path: <linux-kernel-owner+w=401wt.eu-S934874AbXLQJve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874AbXLQJve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 04:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762985AbXLQJvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 04:51:25 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:45591 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763452AbXLQJvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 04:51:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: mvtodevnull@gmail.com
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Mon, 17 Dec 2007 10:49:05 +0100
User-Agent: KMail/1.9.6
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Daniel Walker" <dwalker@mvista.com>,
       "Ray Lee" <ray-lk@madrabbit.org>,
       "Simon Holm =?iso-8859-1?q?Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <47661CA1.3080808@lwfinger.net> <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
In-Reply-To: <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712171049.06291.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 December 2007 08:17:58 mvtodevnull@gmail.com wrote:
> On Dec 17, 2007 1:52 AM, Larry Finger <larry.finger@lwfinger.net> wrote:
> >
> > One major difference between bcm43xx-SoftMAC and b43-mac80211 is that the former always used a fixed
> > rate; whereas mac80211 tries to adjust the bit rate according to the transmission conditions.
> > Perhaps it isn't working quite right in your case because of some peculiarity of your AP. IIRC, you
> > have an 802.11b AP. If so, you will get the same bit speed behavior for mac80211 as for bcdm43xx by
> > issuing a 'sudo iwconfig eth1 rate 11M' command.
> 
> I don't know what happened before, but after a reboot, I can't repeat
> the 200 kB/s speed. It's back down to 40 kB/s, just like originally. I
> didn't move the laptop, or the ap, the only thing I can think of that
> might have changed is the noise level. FWIW, link quality is
> consistently the same or better with b43.
> 
> Anyway, I'd noticed before that the bit rate starts at 1 Mb/s and
> quickly scales to 11 Mb/s, but I tried setting it manually anyway and
> didn't see any change. In fact, I set the rate to 5.5 Mb/s as well as
> 1 Mb/s and the download speed was the same with all three (around
> 30-40 kB/s).

Are you working with wireless-2.6's #everything branch?

-- 
Greetings Michael.
