Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZGHQra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZGHQra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZGHQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:47:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZGHQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:47:21 -0400
Message-ID: <4A54CD65.1050902@zytor.com>
Date: Wed, 08 Jul 2009 09:46:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: tridge@samba.org, Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090702214646.GD1485@ucw.cz> <19021.12158.915384.574218@samba.org> <20090702223349.GA30840@elf.ucw.cz> <19021.14217.587592.808935@samba.org> <20090702224446.GD30840@elf.ucw.cz> <19021.18919.560478.630755@samba.org> <20090708092133.GC24385@elf.ucw.cz>
In-Reply-To: <20090708092133.GC24385@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> But ... it was, and there is still possibility of just using position
> in directory to avoid collisions completely.

I was just going to ask this.  Rather than using a random number, we
should use something based on the position in the directory, and I
suspect we should still verify that it is unique (since some FAT
implementation may garbage-collect the directory thereby moving the offset.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

