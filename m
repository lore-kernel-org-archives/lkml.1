Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYGCNDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYGCNDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYGCND3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:03:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57744 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYGCND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:03:27 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Valdis.Kletnieks@vt.edu, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, arjan@infradead.org
In-Reply-To: <1215089112.10393.544.camel@pmac.infradead.org>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	 <1215077028.10393.497.camel@pmac.infradead.org>
	 <65663.1215080245@turing-police.cc.vt.edu>
	 <1215081029.10393.517.camel@pmac.infradead.org>
	 <68763.1215084867@turing-police.cc.vt.edu>
	 <1215087695.10393.538.camel@pmac.infradead.org>
	 <1215088905.9721.86.camel@linux.site>
	 <1215089112.10393.544.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 15:03:32 +0200
Message-Id: <1215090212.9721.91.camel@linux.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+gobTm/iGrIFhzCztyyD44r7Vp1bfjHqo06EM
 BmE9yJ+N/5qj1NKKugTRt/6IhlJi5VLVxvBBBy6Or+bTQs1rOy
 d2sggZXzRoHEoF9h/e4MSl0C4VuFvEN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 13:45 +0100, David Woodhouse wrote:
> On Thu, 2008-07-03 at 14:41 +0200, Kay Sievers wrote:
> > Headers are not needed for bootup, firmware might be. :) But /usr
> > might be on a different partition/disk/storage at the time we need it,
> > right?
> > 
> > I would say /usr/lib/firmware should not even exist, udev does
> > intentionally not even look there.
> 
> Not /usr/lib/firmware. Currently, when you run 'make firmware_install',
> it gets installed to usr/lib/firmware _within_ the kernel build
> directory. And you're expected to copy it from there (or override with
> 'make INSTALL_FW_PATH=/lib/firmware firmware_install')

Ah, ok. So by default "make modules_install" installs in the rootfs, but
"make firmware_install" installs in the build directory? Hmm ...

Thanks,
Kay

