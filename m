Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbZGHHnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbZGHHnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbZGHHmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:42:32 -0400
Received: from mail.samba.org ([66.70.73.150]:39499 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339AbZGHHm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:42:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19028.19210.992993.643974@samba.org>
Date: Wed, 8 Jul 2009 17:30:18 +1000
To: Jamie Lokier <jamie@shareable.org>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090706200431.GC13638@shareable.org>
References: <alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
	<19021.63615.450348.192109@samba.org>
	<20090706200431.GC13638@shareable.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

 > I think it's ok to break that compatibility if dualnames is off,
 > because that's unfortunately the best available compromise.

You probably noticed this, but the patch that has been put in only
changes the shortname setting when dualnames is off.

Cheers, Tridge
