Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbXJ2CIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbXJ2CIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXJ2CIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:08:01 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:21559 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbXJ2CIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:08:01 -0400
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc1-git4: Reported regressions from 2.6.23
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, rjw@sisk.pl,
       torvalds@linux-foundation.org
In-reply-To: <20071028.181759.148922611.davem@davemloft.net>
References: <200710282351.56284.rjw@sisk.pl> <20071028.181759.148922611.davem@davemloft.net>
Message-Id: <E1ImK2o-0008IJ-Ur@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Mon, 29 Oct 2007 03:07:58 +0100
X-OriginalArrivalTime: 29 Oct 2007 02:07:59.0612 (UTC) FILETIME=[876E8BC0:01C819D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>
>> Subject        : Settings to /proc/sys/net/ipv[46]/conf/all are
>> not propagated. via sysctl too
>> Submitter     : Serge van den Boom <svdb+linux-kernel-bugs@stack.nl>
>> References    : http://bugzilla.kernel.org/show_bug.cgi?id=9224
>> Handled-By    : Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>
> I am to understand, from a reply from Herbert Xu, that this issue has
> existed a long time, definitely since before 2.6.22, therefore it
> doesn't belong on the regression list.

I'm fairly sure that this originates with 2.6.21 as it looks very similar to
http://bugzilla.kernel.org/show_bug.cgi?id=8519
which I filed at that time and which I traced to 8030f54499925d07.

I've never been convinced that that change was correct, but as it now "works
for me" due to changes in the Debian default configuration files, I decided
to not follow up.

Of course, not honoring 'all' is more obviously a bug than not honoring
'default' for existing interfaces.

I've added a comment to #8519.

Hope this helps,
Frans Pop
