Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXGZNFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXGZNFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXGZNFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:05:38 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:49297 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbXGZNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:05:37 -0400
Date: Thu, 26 Jul 2007 08:06:24 -0500 (CDT)
Message-Id: <20070726.080624.94043434.yoshfuji@linux-ipv6.org>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM:
 Introduce pm_power_off_prepare"
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <200707261412.33839.rjw@sisk.pl>
References: <200707251446.56809.rjw@sisk.pl>
	<20070725.102840.72654660.yoshfuji@linux-ipv6.org>
	<200707261412.33839.rjw@sisk.pl>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In article <200707261412.33839.rjw@sisk.pl> (at Thu, 26 Jul 2007 14:12:33 +0200), "Rafael J. Wysocki" <rjw@sisk.pl> says:

> On Wednesday, 25 July 2007 17:28, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> > Hello.
> > 
> > In article <200707251446.56809.rjw@sisk.pl> (at Wed, 25 Jul 2007 14:46:55 +0200), "Rafael J. Wysocki" <rjw@sisk.pl> says:
> > 
> > > On Wednesday, 25 July 2007 00:19, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> > :
> > > > Linux 2.6.23-rc1 fails to power off my ThinkPad T42.
> > > > Git-bisect told me that the following commit is to blame,
> > > > and by reverting that commit, it works appropriately.
> > > 
> > > (1) Can you please apply the appended patch and see if the message gets
> > >     printed when you try to power off the system?
> > 
> > Yup, I got it.  Last lines are:
:
> Can you please check if the appended patch helps?

Yes, it definitely does.  Thank you.

Regards,

--yoshfuji
