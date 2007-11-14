Return-Path: <linux-kernel-owner+w=401wt.eu-S1764731AbXKNVDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764731AbXKNVDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXKNVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:03:15 -0500
Received: from pils.linux-kernel.at ([213.129.242.82]:55032 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760AbXKNVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:03:14 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 16:03:14 EST
Message-ID: <473B600E.9030703@linux-kernel.at>
Date: Wed, 14 Nov 2007 21:52:30 +0100
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux on Alpha processors <axp-list@redhat.com>,
       linux-kernel@vger.kernel.org, Jay Estabrook <jay.estabrook@hp.com>
Subject: Question about F_RDLCK and F_WRLCK on alpha
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Can someone explain me, why we have different define's for WRLCK and
RDLCK within alpha kernel headers:

Alpha system:

asm/fcntl.h:#define F_RDLCK             1
asm-generic/fcntl.h:#ifndef F_RDLCK
asm-generic/fcntl.h:#define F_RDLCK             0
bits/fcntl.h:#define F_RDLCK            1       /* Read lock.  */

Intel system:

asm-generic/fcntl.h:#ifndef F_RDLCK
asm-generic/fcntl.h:#define F_RDLCK             0
bits/fcntl.h:#define F_RDLCK            0       /* Read lock.  */

I would say F_RDLCK should better be 0 as in i386, but I also guess that
changing this would break many things, wouldn't it?

I don't want to tell you my (long) story, how I found that and why I was
searching for it :-(

(Jay, you know what I'm talkin' about, don't you?)


Well, maybe my kernel headers are just packaged up like crap!?


Best,
 Oliver

