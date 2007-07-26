Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXGZOfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXGZOfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbXGZOfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:35:32 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:49307 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204AbXGZOfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:35:31 -0400
Date: Thu, 26 Jul 2007 09:36:19 -0500 (CDT)
Message-Id: <20070726.093619.31113410.yoshfuji@linux-ipv6.org>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       yoshfuji@linux-ipv6.org
Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM:
 Introduce pm_power_off_prepare"
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <200707261629.55741.rjw@sisk.pl>
References: <200707261412.33839.rjw@sisk.pl>
	<20070726.080624.94043434.yoshfuji@linux-ipv6.org>
	<200707261629.55741.rjw@sisk.pl>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <200707261629.55741.rjw@sisk.pl> (at Thu, 26 Jul 2007 16:29:55 +0200), "Rafael J. Wysocki" <rjw@sisk.pl> says:

> > Yes, it definitely does.  Thank you.
> 
> OK, so here it goes again with a changelog:
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Generally, sysdev_shutdown() should be called after the ACPI preparation for
> powering the system off.  To make it happen, we can separate sysdev_shutdown()
> from device_shutdown() and call it directly wherever necessary.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

--yoshfuji
