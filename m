Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847Ab0AGVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0AGVgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794Ab0AGVgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:36:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1625 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0AGVgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:36:17 -0500
Subject: Re: [PATCH] lib/vsprintf.c: Add %pMF to format FDDI bit reversed
 MAC  addresses
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       David Miller <davem@davemloft.net>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <e2d7436a1001071318l75750b29uece2a61884538d5b@mail.gmail.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090208954A@mi8nycmail19.Mi8.com>
	 <1262888625.10429.23.camel@Joe-Laptop.home>
	 <e2d7436a1001071318l75750b29uece2a61884538d5b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 13:36:15 -0800
Message-ID: <1262900175.10429.75.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 22:18 +0100, Michał Mirosław wrote: 
> Something like the following might be smaller and faster - no
> functions and their calls
> int rev = (fmt[1] == 'F');
> p = pack_hex_byte(p, rev ? bitrev8(addr[i]) : addr[i]);

Right, better.  Just 6 bytes (x86).  Resubmitting.


