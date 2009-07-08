Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZGHK1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZGHK1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZGHK1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:27:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53798 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZGHK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:27:22 -0400
Date: Wed, 8 Jul 2009 12:27:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <19028.19921.30399.762710@samba.org>
Message-ID: <alpine.LSU.2.00.0907081146290.29609@fbirervta.pbzchgretzou.qr>
References: <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
 <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org> <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org>
 <20090707195129.GB24203@elf.ucw.cz> <19028.19921.30399.762710@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2009-07-08 09:42, tridge@samba.org wrote:
>What I said in the patch help text is:
>
>	  That means that long filenames created with this option
>	  disabled will not be accessible at all to operating systems
>	  that do not understand the VFAT extensions.
>
>that means you have to choose 8.3 names if you want to copy files onto
>a SD card and have those files visible to digital cameras. That is not
>actually much of a change from how things behave without my patch for
>current 8.3 only cameras. As Jan discovered, cameras tend to be pretty
>fussy about the format of the filenames for files. His particular
>camera wants the filenames to be dscfNNNN.jpg, which means that he
>needed to be careful about choosing file names with current kernels as
>well.

In the large picture, the problem is not so much about devices that
restrict themselves to 8.3, such as DCIM-compatible cameras. They
"only" accept 8.3, so there is no point in trying to use a long
name because the software won't look for it in the first place.

It is much more with devices that are commonly operated with long
names - multimedia players come to mind - and these "always"
want a valid 8.3.

>> Perhaps camera vendors fear patents, too.
>
>quite likely they want to minimise their costs, and not paying for a
>patent license they don't need is one way to do that.

Well and there's always some vendors (the more so the one-product
vendors) not paying the royalities they are supposed to.
