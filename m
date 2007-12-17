Return-Path: <linux-kernel-owner+w=401wt.eu-S934558AbXLQCRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558AbXLQCRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXLQCRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:17:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:31831 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXLQCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EzRoFiSNvmwj1S/0osJZgw+O+GMsjO6nUe4DlYvCTR/OaRjpfPGPSdRGstyZKibhjegcZmylzAGpYeYTB6FLfsWoYmgjgmTnVyxClwzUHBqHI+wZsFJocOvnypkbJQzv1a0OS519uocDtzbznWwojX8idcgzlKdlXbqveAqayuk=
Message-ID: <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>
Date: Sun, 16 Dec 2007 21:17:03 -0500
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
In-Reply-To: <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>
	 <476326A1.6090404@lwfinger.net>
	 <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>
	 <47633BAE.6040604@lwfinger.net>
	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>
	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>
	 <47637FDA.2030303@lwfinger.net>
	 <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 15, 2007 7:38 AM,  <mvtodevnull@gmail.com> wrote:
>
> I'll build latest wireless git without ipv6 late tonight.

Ok, built and tested, and it's actually faster! Although still not as
fast as bcm43xx or softmac or whatever the problem is, I was getting a
steady 200 kB/s (as opposed to 500 kB/s for bcm43xx with the same
file/server). I'm not sure if it was the absence of ipv6 or the
commits included in updating my git repository though. Either way, I'm
fairly happy that I'm out of dial-up speed territory.

It'd be nice to be able to fully shake loose whatever is causing the
speed drain - and I call it a drain since sometimes the connection
starts out much faster, but slowly throttles down to whatever speed
it'll stick at (used to be 40 kB/s, but now is 200 kB/s). It does seem
to be like a cap or limit, as in if I download two files, each one
will download at 100 kB/s.

If anyone can help I'd really appreciate it. I know that bcm43xx will
someday be dropped, and when that day comes, it'd be nice if people
with this hardware have at least similar performance with b43 (myself
especially).

Thanks again,
Rob
