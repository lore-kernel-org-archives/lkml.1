Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZGKAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZGKAP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 20:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbZGKAPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 20:15:14 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47831 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbZGKAPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 20:15:13 -0400
Date: Sat, 11 Jul 2009 01:14:59 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: tridge@samba.org, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
Message-ID: <20090711001459.GH30322@shareable.org>
References: <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr> <19021.17576.808138.476600@samba.org> <alpine.LSU.2.00.0907030149020.17183@fbirervta.pbzchgretzou.qr> <19021.20449.732095.210252@samba.org> <alpine.LSU.2.00.0907030254180.22039@fbirervta.pbzchgretzou.qr> <19021.24134.319252.776778@samba.org> <alpine.LSU.2.00.0907030350330.24650@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0907030350330.24650@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> On Friday 2009-07-03 03:26, tridge@samba.org wrote:
> >
> > > Making WINNT the default would cause many a `ls` output to just
> > > scream at me in uppercaps because there are programs that
> > > create long names with all-uppers.
> >
> >well, you could also argue that having WINNT in effect does the
> >'correct' thing. It causes ls to display the name that is actually in
> >the filesystem. 
> >
> >I think the current default for VFAT on Linux is rather misleading. It
> >always displays 8.3 names as lowercase,
> 
> There is no misleading in that, since VFAT is rather case-insensitive.

It's case-insensitive for searches, but:

 - With the "posix" option, you can have multiple names with different cases.

 - It still preserves case.  I've got (Linux!) devices which copy
   files from FAT flash media onto their internal hard disk which is
   ext3, and then fail to work if the files on ext3 have the wrong case.

-- Jamie
