Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZGAKI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZGAKI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZGAKIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:08:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44656 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372AbZGAKIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:08:20 -0400
Date: Wed, 1 Jul 2009 11:09:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701110934.2f43591c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090630063102.GB1351@ucw.cz>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What happens on collision? With 60000 entries in directory, there will
> be 50% chance of collision. BAD.

Far more surely - its a birthday paradox.

> Why not use something like position in directory instead of random
> number?

Agreed 100%. I'm also not sure it should be called "vfat" when operating
in this mode as it's not vfat any more - it needs a new name.

Alan
