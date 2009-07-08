Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZGHHmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZGHHmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbZGHHm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:42:28 -0400
Received: from mail.samba.org ([66.70.73.150]:39477 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbZGHHm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:42:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19028.19921.30399.762710@samba.org>
Date: Wed, 8 Jul 2009 17:42:09 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090707195129.GB24203@elf.ucw.cz>
References: <87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
	<19021.63615.450348.192109@samba.org>
	<alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr>
	<19025.63119.656216.431469@samba.org>
	<20090707195129.GB24203@elf.ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > It worked before. You claim that devices not understanding long
 > filenames are now extinct, but that camera is the counterexample.

I certainly never claimed that devices that don't understand long
filenames are extinct! I own more than one digital camera that doesn't
understand long filenames.

What I said in the patch help text is:

	  That means that long filenames created with this option
	  disabled will not be accessible at all to operating systems
	  that do not understand the VFAT extensions.

that means you have to choose 8.3 names if you want to copy files onto
a SD card and have those files visible to digital cameras. That is not
actually much of a change from how things behave without my patch for
current 8.3 only cameras. As Jan discovered, cameras tend to be pretty
fussy about the format of the filenames for files. His particular
camera wants the filenames to be dscfNNNN.jpg, which means that he
needed to be careful about choosing file names with current kernels as
well.

 > Perhaps camera vendors fear patents, too.

quite likely they want to minimise their costs, and not paying for a
patent license they don't need is one way to do that. I also expect
that not many of their customers put files onto the camera from a
computer, as opposed to taking them off. 

Cheers, Tridge
