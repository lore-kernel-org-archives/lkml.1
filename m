Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZGCB7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZGCB7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZGCB7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:59:35 -0400
Received: from mail.samba.org ([66.70.73.150]:51554 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZGCB7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:59:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Message-ID: <19021.26102.80885.330380@samba.org>
Date: Fri, 3 Jul 2009 11:59:18 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > The cam does not have a problem with long filenames,A $,1rt(B 

That is curious. When you use a long filename (ie. a real long
filename, not a mixed case 8.3 name), if you ask the camera for
details on the photo, does it show the long filename you chose, or
does it show a 8.3 "mangled" name, like ABC~01.JPG.

 > as said, it works on any to-date vanilla/distro Linux kernel,
 > which, if I understood mount(8) right, always create a long
 > filename due to me using a lowercase filename in conjunction with
 > the default shortname=mixed.

I think you'll find it works as these kernels will be automatically
creating a "mangled" 2nd name in 8.3 format for each file with a long
name.

If you can actually see a true long filename like LongFilename.jpg on
the cameras LCD then it will warrant more investigation, and in that
case I'll try to get hold of the same model of camera and have a play
with it.

Cheers, Tridge
