Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbXLOB7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbXLOB7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXLOB71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:59:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:1546 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbXLOB70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:59:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FLwDxmdzcTVbMaxLgYvY1qILuHSOpLGDriNHpYdlPQeqkz2W+7mlwT5qxN1sFngytVeYlh1H49k2an9KSwItrf2KgBzsorRXWvmg+uvPKaAIHLVz48fjpiBm962T15nZeXM37Vrb+8C7oMhweuL0gtzJ0FNEaB70d6PNfrIffJI=
Message-ID: <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>
Date: Fri, 14 Dec 2007 20:59:25 -0500
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
In-Reply-To: <476326A1.6090404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <1197637194.7549.10.camel@odie.local>
	 <200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>
	 <476326A1.6090404@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 7:58 PM, Larry Finger <larry.finger@lwfinger.net> wrote:
> Rafael J. Wysocki wrote:
> >
> > Actually, can you explain why, from the technical point of view, the version 4
> > firware is better than version 3, please?
>
> I will be very interested in Michael's answer to this question; however, my experience is that it
> doesn't make much difference if your device is supported by both V3 and V4 firmware. This impression
> was obtained by comparing BCM4318 and BCM4311/1 devices with b43 and b43legacy.
>
> Note that 802.11b and early BCM4306 devices are not supported by V4 firmware.

Could this be the reason my BCM94311MCG rev 1 receives such terrible
performance with b43 but works well with bcm43xx? The device is
802.11b/g but my router is 802.11b. I filed a report on this issue
here: https://bugzilla.redhat.com/show_bug.cgi?id=413291

I was told by Michael that I would have to fix it myself, and I am
trying, but the learning curve is a little steep. If this is relevant,
I might at least have some direction to go in.
