Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbZGHJXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbZGHJXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZGHJXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:23:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40648 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbZGHJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:23:24 -0400
Date: Wed, 8 Jul 2009 11:21:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090708092133.GC24385@elf.ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090702214646.GD1485@ucw.cz> <19021.12158.915384.574218@samba.org> <20090702223349.GA30840@elf.ucw.cz> <19021.14217.587592.808935@samba.org> <20090702224446.GD30840@elf.ucw.cz> <19021.18919.560478.630755@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19021.18919.560478.630755@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-03 09:59:35, tridge@samba.org wrote:
> Hi Pavel,
> 
>  > That's why we have ethernet checksums. 
> 
> which of course just changes the number of bits. The argument remains
> the same. 

Ok, so what is your estimate of XP crash probability?

>  > It already _was_ perfect before you started patching it.
> 
> wow, I really didn't expect the objection to my patch to be that VFAT
> is perfect!

But ... it was, and there is still possibility of just using position
in directory to avoid collisions completely.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
