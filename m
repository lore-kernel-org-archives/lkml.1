Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZGHWOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZGHWOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZGHWOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:14:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54442 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZGHWOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:14:15 -0400
Date: Wed, 8 Jul 2009 15:14:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090708221413.GH15111@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200907012019.53932.rusty@rustcorp.com.au> <20090702214646.GD1485@ucw.cz> <19021.12158.915384.574218@samba.org> <20090702223349.GA30840@elf.ucw.cz> <19021.14217.587592.808935@samba.org> <20090702224446.GD30840@elf.ucw.cz> <19021.18919.560478.630755@samba.org> <20090708092133.GC24385@elf.ucw.cz> <20090708142520.GA7817@linux.vnet.ibm.com> <19029.4803.604820.157625@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19029.4803.604820.157625@samba.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 07:42:27AM +1000, tridge@samba.org wrote:
> Hi Paul,
> 
> These probabilities are way off. They assume that whatever interaction
> happens in XP has infinite memory. The testing I've done indicates
> that the memory for this interaction is very small (maybe 3 or 4? it's
> hard to know precisely).

Good to know!  I will rework assuming that the memory is 4, let me
know if you learn more.

> I've also confirmed this with lots of testing. If the probability was
> 39% for any directory size then I would have found it.

This new information will likely reduce the predicted probability of
bluescreen by several orders of magnitude for large directories.  Not
that much effect for small directories, but not a real issue given
how low the probabilities are to begin with.

> In all my testing I did not once produce a XP crash with the full
> patch. To produce the XP crash I needed to have a reduced version of
> the patch with less randomness.

Well, let's see if I can produce a reasonably realistic model.  :-)
(I knew I should have gotten more sleep last night!!!)

							Thanx, Paul
