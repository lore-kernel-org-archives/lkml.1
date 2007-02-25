Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbXBYSCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbXBYSCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932635AbXBYSCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:02:53 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43926 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932649AbXBYSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:02:51 -0500
Date: Sun, 25 Feb 2007 19:02:51 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org, Bob Tracy <rct@gherkin.frus.com>,
       Mark Brown <broonie@sirena.org.uk>,
       YOSHIFUJI Hideaki / =?utf-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>,
       Pete Clements <clem@clem.clem-digital.net>,
       Sid Boyce <g3vbv@blueyonder.co.uk>,
       Chuck Lever <chuck.lever@oracle.com>, Andreas Schwab <schwab@suse.de>,
       Dave Jones <davej@redhat.com>
Subject: 2.6.21-rc1: known regressions (part 3)
Message-ID: <20070225180251.GD12392@stusta.de>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.21-rc1 compared to 2.6.20
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : forcedeth: skb_over_panic
References : http://bugzilla.kernel.org/show_bug.cgi?id=8058
Submitter  : Albert Hopkins <kernel@marduk.letterboxes.org>
Status     : unknown


Subject    : natsemi ethernet card not detected correctly
References : http://lkml.org/lkml/2007/2/23/4
             http://lkml.org/lkml/2007/2/23/7
Submitter  : Bob Tracy <rct@gherkin.frus.com>
Caused-By  : Mark Brown <broonie@sirena.org.uk>
Handled-By : Mark Brown <broonie@sirena.org.uk>
Patch      : http://lkml.org/lkml/2007/2/23/142
Status     : patch available


Subject    : request_module: runaway loop modprobe net-pf-1
References : http://lkml.org/lkml/2007/2/21/206
Submitter  : YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Caused-By  : Kay Sievers <kay.sievers@vrfy.org>
             commit c353c3fb0700a3c17ea2b0237710a184232ccd7f
Handled-By : Greg KH <greg@kroah.com>
Status     : problem is being discussed


Subject    : IPV6=m, SUNRPC=y compile error
References : http://bugzilla.kernel.org/show_bug.cgi?id=8050
             http://lkml.org/lkml/2007/2/12/442
             http://lkml.org/lkml/2007/2/20/384
Submitter  : Michael-Luke Jones <mlj28@cam.ac.uk>
             Pete Clements <clem@clem.clem-digital.net>
             Sid Boyce <g3vbv@blueyonder.co.uk>
Caused-By  : Chuck Lever <chuck.lever@oracle.com>
Handled-By : YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Status     : patch available


Subject    : WARNING: "compat_agp_ioctl" undefined!
References : http://lkml.org/lkml/2007/2/21/272
Submitter  : Andreas Schwab <schwab@suse.de>
Handled-By : Dave Jones <davej@redhat.com>
Status     : patch available


