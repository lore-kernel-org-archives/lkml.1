Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYCRBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYCRBBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYCRBBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:01:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34088 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbYCRBBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:01:08 -0400
Subject: Re: [PATCH 7/8] Remove current_tick_length()
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0803151812020.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org>
	 <20080314195737.153531685@linux-m68k.org>
	 <1205548860.6122.55.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150429500.1791@scrub.home>
	 <1205552909.6122.63.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150511580.1791@scrub.home>
	 <2c0942db0803150929q7cc628f8h18269f10daec8ab1@mail.gmail.com>
	 <Pine.LNX.4.64.0803151812020.1791@scrub.home>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 18:01:04 -0700
Message-Id: <1205802064.28128.74.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-15 at 18:14 +0100, Roman Zippel wrote:
> Hi,
> 
> On Sat, 15 Mar 2008, Ray Lee wrote:
> 
> > Then make the original function an inline. With -O2 it should compile
> > to exactly the same thing.
> 
> This would also defeat John's intention of keeping the value static.

Well, don't mistake me for being fanatical about it. Having the values
be static is cleaner, but if its a real performance issue, then clearly
performance wins.

I do like Ray's suggestion, and think using the inline'd function is
preferred to the raw variable, as it better establishes through use if
nothing else, the read-only nature of the value outside of ntp.

thanks
-john

