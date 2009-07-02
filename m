Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZGBVq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZGBVq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZGBVqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:46:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60604 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbZGBVqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:46:50 -0400
Date: Thu, 2 Jul 2009 23:46:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702214646.GD1485@ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907012019.53932.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-01 20:19:51, Rusty Russell wrote:
> On Tue, 30 Jun 2009 04:01:03 pm Pavel Machek wrote:
> > > +config VFAT_FS_DUALNAMES
> > > +	bool "VFAT dual names support"
> > > +	depends on VFAT_FS
> >
> > Defaults should be back-compatible.
> 
> Hi Pavel,
> 
> I disagree with this: given there's been testing with no known issues, it's 
> not a back compat question.

The testing uncovered some pretty serious issues. ('Causes XP to
bluescreen').
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
