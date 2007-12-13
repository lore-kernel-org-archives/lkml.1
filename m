Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbXLMPRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbXLMPRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXLMPRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:17:47 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:42482 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbXLMPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:17:46 -0500
Date: Thu, 13 Dec 2007 16:17:08 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <200712030936.25363.osterried@jesse.de>
Message-ID: <Pine.LNX.4.64.0712131606410.24173@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
 <200709290614.02918.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0712021603060.26896@bizon.gios.gov.pl>
 <200712030936.25363.osterried@jesse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2055744295-1197559028=:24173"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2055744295-1197559028=:24173
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 3 Dec 2007, Thomas Osterried wrote:

> On the machine which has troubles, the bug occured within about 10 days
> During these days, the amount of dirty pages increased, up to 400MB.
> I have testet kernel 2.6.19, 2.6.20, 2.6.22.1 and 2.6.22.10 (with our con=
fig),
> and even linux-2.6.20 from ubuntu-sever. They have all shown that behavio=
ur.

<CUT>

> 10 days ago, i installed kernel 2.6.18.5 on this machine (with backported
> 3ware controller code). I'm quite sure that this kernel will now fixes ou=
r
> severe stability problems on this production machine (currently:
> Dirty:  472 kB, nr_dirty 118).
> If so, it's the "lastest" kernel i found usable, after half of a year of =
pain.

Strange, my tests show that both 2.6.18(.8) and 2.6.19(.7) are OK and the=
=20
first wrong kernel is 2.6.20.

BTW: Could someone please look at this problem? I feel little ignored and=
=20
in my situation this is a critical regression.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2055744295-1197559028=:24173--
