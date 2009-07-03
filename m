Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZGCBun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZGCBun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZGCBuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:50:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40696 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbZGCBu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:50:27 -0400
Date: Fri, 3 Jul 2009 03:50:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <19021.23231.213863.726785@samba.org>
Message-ID: <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
 <alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr> <19021.19842.663727.146474@samba.org> <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-07-03 03:11, tridge@samba.org wrote:
>
> 1) do what I did in the May patch, which is to force
>    VFAT_SFN_CREATE_WINNT when the patch code triggers.
>
> 2) force VFAT_SFN_CREATE_WINNT, but also if the name is mixed case
> within either prefix or extension (such as "Mixed.TXT") then force
> that part of the name to all lowercase. So "Mixed.TXT" would become
> "mixed.TXT" on disk.
>
>The 2nd choice maximises compatibility with devices that don't
>understand long filenames (such as Jan's camera). The first option
>keeps case preservation for devices that do understand long filenames.

The cam does not have a problem with long filenames — as said, it works 
on any to-date vanilla/distro Linux kernel, which, if I understood 
mount(8) right, always create a long filename due to me using a 
lowercase filename in conjunction with the default shortname=mixed.
