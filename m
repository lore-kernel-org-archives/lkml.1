Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZGBWpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZGBWpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZGBWow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:44:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55722 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZGBWow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:44:52 -0400
Date: Fri, 3 Jul 2009 00:44:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702224446.GD30840@elf.ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090702214646.GD1485@ucw.cz> <19021.12158.915384.574218@samba.org> <20090702223349.GA30840@elf.ucw.cz> <19021.14217.587592.808935@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19021.14217.587592.808935@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-03 08:41:13, tridge@samba.org wrote:
> Hi Pavel,
> 
>  > So you know it causes XP to bluescreen, but can not reproduce that. So
>  > what? Someone, somewhere _will_ reproduce it.
> 
> yes, like someone, somewhere will get data corruption in a TCP
> connection because the checksum is quite weak and networking hardware
> ain't perfect.

That's why we have ethernet checksums. 

> Once the probabilties become small enough then it is normal to accept
> imperfection in operating systems. If I could make it perfect I
> but I haven't thought of a way to do that while being absolutely sure
> of maintaining the full strength of the legal defence.

It already _was_ perfect before you started patching it.

> If you find a way to actually produce this problem in a way that is
> realistic for Linux users then let me know. Otherwise I think it is
> the best option we have, imperfect though it is. 

So, you know that particular option will cause someone's XP to
bluescreen, and  you still want it to default to "Y"?
											Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
