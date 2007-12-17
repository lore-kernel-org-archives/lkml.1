Return-Path: <linux-kernel-owner+w=401wt.eu-S936467AbXLQWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936467AbXLQWEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760913AbXLQWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:04:41 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:63949 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbXLQWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TrZxfGXobDWjIQrEyCE2oOlpUQj06h9YQl5FQXDoYXg9X3fU0KklJ8+5OBH4zQSdBLb8F6dx0wrvEEoFsVoAPVUtKdT//D/zH0XZRQYf2Zzv5z3worBciXlbYtFUZC/4OIkwUU13PspkMAyLGFAg/NB+asva9ZDuzSMkqNVloU0=
Message-ID: <520b60a90712171404v647d3d62h69e61d223040779b@mail.gmail.com>
Date: Mon, 17 Dec 2007 17:04:37 -0500
From: mvtodevnull@gmail.com
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Daniel Walker" <dwalker@mvista.com>,
       "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <520b60a90712170235p4c0bc0f5ybf64da0853f06d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <47661CA1.3080808@lwfinger.net>
	 <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
	 <200712171049.06291.mb@bu3sch.de>
	 <520b60a90712170215g7f3c8a2by7fdd74a1cdd1566f@mail.gmail.com>
	 <520b60a90712170235p4c0bc0f5ybf64da0853f06d6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 5:35 AM,  <mvtodevnull@gmail.com> wrote:
> If this is a mac80211 related problem, then other systems connecting
> to the same ap and using mac80211 would also be affected? Like I said
> earlier, there are five machines connecting to this ap, and I just
> realized one of them has a ralink card that uses the rt2x00 driver,
> which I believe is mac80211. That system doesn't have this problem,
> which leads me to believe it may not be mac80211 after all, although I
> wouldn't rule it out.
>

This also doesn't seem to be related to firmware version. I forced my
device to use b43legacy, and the results were identical with the
version 3 firmware.
