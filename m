Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbZGCCJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbZGCCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZGCCJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:09:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51456 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbZGCCJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:09:47 -0400
Date: Fri, 3 Jul 2009 04:09:50 +0200 (CEST)
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
In-Reply-To: <19021.26102.80885.330380@samba.org>
Message-ID: <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
 <alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr> <19021.19842.663727.146474@samba.org> <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
 <19021.26102.80885.330380@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-07-03 03:59, tridge@samba.org wrote:
>
> > The cam does not have a problem with long filenames 牴 
>
>That is curious. When you use a long filename (ie. a real long
>filename, not a mixed case 8.3 name), if you ask the camera for
>details on the photo,

No-no, as previously mentioned it ignores filenames not in the
format of dscf????.jpg. But if I interpret the hexdump right,
standard Linux creates a long name *anyway*, even for names
fitting in 8.3, if it's lowercase:

│00bce510 79 39 79 39 03 00 f5 5b-79 39 95 4b 00 00 00 00 |y9y9? ?[y9?K    |    
│00bce520 41 67 00 6f 00 64 00 64-00 61 00 0f 00 27 6d 00 |Ag o d d a ? 'm |    
│00bce530 6e 00 2e 00 7a 00 69 00-70 00 00 00 00 00 ff ff |n . z i p     ??|    
│00bce540 47 4f 44 44 41 4d 4e 20-5a 49 50 20 00 64 d2 20 |GODDAMN ZIP  d? |    
