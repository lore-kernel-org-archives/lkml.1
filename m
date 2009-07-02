Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZGBXz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZGBXz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZGBXzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:55:13 -0400
Received: from ozlabs.org ([203.10.76.45]:37159 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZGBXzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:55:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Date: Fri, 3 Jul 2009 09:25:07 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org> <200907012019.53932.rusty@rustcorp.com.au> <20090702214646.GD1485@ucw.cz>
In-Reply-To: <20090702214646.GD1485@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907030925.08100.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 07:16:46 am Pavel Machek wrote:
> On Wed 2009-07-01 20:19:51, Rusty Russell wrote:
> > On Tue, 30 Jun 2009 04:01:03 pm Pavel Machek wrote:
> > > > +config VFAT_FS_DUALNAMES
> > > > +	bool "VFAT dual names support"
> > > > +	depends on VFAT_FS
> > >
> > > Defaults should be back-compatible.
> >
> > Hi Pavel,
> >
> > I disagree with this: given there's been testing with no known issues,
> > it's not a back compat question.
>
> The testing uncovered some pretty serious issues. ('Causes XP to
> bluescreen').

No, read more carefully: testing revealed "couldn't cause XP to bluescreen".  
It took a deliberately hobbled version of the patch to tickle the XP bug, 
under a day of stress testing.

Cheers,
Rusty.
