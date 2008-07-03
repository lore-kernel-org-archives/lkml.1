Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYGCMl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYGCMl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759770AbYGCMlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:41:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:61141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759758AbYGCMlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:41:39 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Valdis.Kletnieks@vt.edu, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, arjan@infradead.org
In-Reply-To: <1215087695.10393.538.camel@pmac.infradead.org>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	 <1215077028.10393.497.camel@pmac.infradead.org>
	 <65663.1215080245@turing-police.cc.vt.edu>
	 <1215081029.10393.517.camel@pmac.infradead.org>
	 <68763.1215084867@turing-police.cc.vt.edu>
	 <1215087695.10393.538.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 14:41:45 +0200
Message-Id: <1215088905.9721.86.camel@linux.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/mkEyKOWzKXN4NlwNEP7qyTJ9QYWG2pa1a+s0
 KoGJWlTZ+cpGH6S41wCgqtvMudcMbYrj5HqY29J5gUEhRQjv/4
 n3jN6lYnAfNWlotGeKIsuxx4RfWKCbe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 13:21 +0100, David Woodhouse wrote:
> On Thu, 2008-07-03 at 07:34 -0400, Valdis.Kletnieks@vt.edu wrote:
> > Actually, FIRMWARE_IN_KERNEL *did* make a difference - it busticated the tg3
> > driver and while fighting with the 'firmware: requesting tigon/tg3_tso.bin'
> > errors I had just inflicted on myself, 
> 
> Just to confirm: that works either with CONFIG_FIRMWARE_IN_KERNEL=y or
> if you run 'make INSTALL_FW_PATH=/lib/firmware firmware_install', right?
> 
> I'm not entirely sure whether we should make 'make firmware_install'
> install to /lib/firmware by default, or to $(O)/usr/lib/firmware as it
> does at the moment.
> 
> The former is consistent with 'make modules_install', and the latter is
> consistent with 'make headers_install'. Both of which have good reasons
> for being the way they are.

Headers are not needed for bootup, firmware might be. :) But /usr might
be on a different partition/disk/storage at the time we need it, right?

I would say /usr/lib/firmware should not even exist, udev does
intentionally not even look there.

Thanks,
Kay

