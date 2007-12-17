Return-Path: <linux-kernel-owner+w=401wt.eu-S935378AbXLQKgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935378AbXLQKgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763025AbXLQKf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:35:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:54974 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761738AbXLQKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XEwkVLcdh1+pTkPd0e5NqR4m96Z46UAEXtoMylT8/mfQmr80Wa/0Dv8HgrDY+pvv+dSvmuBoVIwI8iD0tU2rf7AtruR/v0wWcuX5puUICSeEsRi1w4JR7irhonEOIjzmmYUzoWxsqCn+Wf3b4E+XZzqz6JnAm2w0DrjUotXE2mE=
Message-ID: <520b60a90712170235p4c0bc0f5ybf64da0853f06d6@mail.gmail.com>
Date: Mon, 17 Dec 2007 05:35:56 -0500
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
In-Reply-To: <520b60a90712170215g7f3c8a2by7fdd74a1cdd1566f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <47661CA1.3080808@lwfinger.net>
	 <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
	 <200712171049.06291.mb@bu3sch.de>
	 <520b60a90712170215g7f3c8a2by7fdd74a1cdd1566f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this is a mac80211 related problem, then other systems connecting
to the same ap and using mac80211 would also be affected? Like I said
earlier, there are five machines connecting to this ap, and I just
realized one of them has a ralink card that uses the rt2x00 driver,
which I believe is mac80211. That system doesn't have this problem,
which leads me to believe it may not be mac80211 after all, although I
wouldn't rule it out.
