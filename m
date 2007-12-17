Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbXLQHSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbXLQHSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 02:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbXLQHR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 02:17:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:60468 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbXLQHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 02:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ToTyoXp4dowqJ4Rcxsr8zKQDTME7fLtJ+DaixBm0WUzSjiXMo9SzLUzcU1gC7HKVWdKXY1KmUBGGijrY4qTHb6bmohGjiWEc7Bbi+CIpMFcyddBTun/afKil4I/ykmP0inAdw8wkYOi6GKVhwDYX42E0WTQrHarWt/R+C4f4VQc=
Message-ID: <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
Date: Mon, 17 Dec 2007 02:17:58 -0500
From: mvtodevnull@gmail.com
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Michael Buesch" <mb@bu3sch.de>,
       "Daniel Walker" <dwalker@mvista.com>, "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <47661CA1.3080808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <476326A1.6090404@lwfinger.net>
	 <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>
	 <47633BAE.6040604@lwfinger.net>
	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>
	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>
	 <47637FDA.2030303@lwfinger.net>
	 <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>
	 <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>
	 <47661CA1.3080808@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 1:52 AM, Larry Finger <larry.finger@lwfinger.net> wrote:
>
> One major difference between bcm43xx-SoftMAC and b43-mac80211 is that the former always used a fixed
> rate; whereas mac80211 tries to adjust the bit rate according to the transmission conditions.
> Perhaps it isn't working quite right in your case because of some peculiarity of your AP. IIRC, you
> have an 802.11b AP. If so, you will get the same bit speed behavior for mac80211 as for bcdm43xx by
> issuing a 'sudo iwconfig eth1 rate 11M' command.

I don't know what happened before, but after a reboot, I can't repeat
the 200 kB/s speed. It's back down to 40 kB/s, just like originally. I
didn't move the laptop, or the ap, the only thing I can think of that
might have changed is the noise level. FWIW, link quality is
consistently the same or better with b43.

Anyway, I'd noticed before that the bit rate starts at 1 Mb/s and
quickly scales to 11 Mb/s, but I tried setting it manually anyway and
didn't see any change. In fact, I set the rate to 5.5 Mb/s as well as
1 Mb/s and the download speed was the same with all three (around
30-40 kB/s).
