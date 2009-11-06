Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbZKFSb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbZKFSb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759266AbZKFSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:31:27 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41025 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136AbZKFSb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=rmk5z4fxhghNziIx+fWzOlq1F7TmMIxMHSm0kyJlwPEjEDMScwZVH9CXHykee4xogH
         MD6BSHIgZrbiwLafipE1P/05axBHRKVtSRRtDuHZnvgVcn9wv7FOfy72uYzOXvSy26nh
         uRIc5mmbM7tL0y1yw9N1ca+xpXPSqOS/Xwsyc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
Date: Fri, 6 Nov 2009 19:30:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
References: <200911031951.05235.bzolnier@gmail.com> <20091106074643.GA5562@ucw.cz> <200911061858.56816.IvDoorn@gmail.com>
In-Reply-To: <200911061858.56816.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200911061930.13069.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 November 2009 18:58:56 Ivo van Doorn wrote:

> drivers/net/staging/rt28{6,7}0 was developed by Ralink and I acked

The original vendor drivers were:
- rt2860
- rt2870
- rt3070
- rt3090

Each weighting ~100 KLOC.

The current staging drivers (rt2860 w/ RT3090 support and rt2870 w/ RT3070
support) are the result of my work on getting staging drivers under control
(+ trying some new strategies of dealing with ugly code) and weight ~75 KLOC
_together_ (they share the wireless stack code).

> the merged for those drivers after the asurance that it was only merged
> to please the users so developers could focus on the rt2x00 version of
> the driver.

Could somebody please explain me (in the public or in the private) what is
the reason behind whole affair about staging drivers because all the time
I feel like I'm missing some important detail here.  It would a lot more
productive than all the things that I could hear about my agenda, my work
or my intellectual abilities in the past.

[ Like I said before I got only interested into them in April this year
  while doing casual staging cleanups and I'm not affiliated with any
  distribution vendor. ]

Thanks.
-- 
Bartlomiej Zolnierkiewicz
