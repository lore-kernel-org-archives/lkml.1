Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZGAKuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZGAKuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZGAKt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:49:56 -0400
Received: from ozlabs.org ([203.10.76.45]:41250 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZGAKtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:49:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Date: Wed, 1 Jul 2009 20:19:51 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz>
In-Reply-To: <20090630063102.GB1351@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907012019.53932.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 04:01:03 pm Pavel Machek wrote:
> > +config VFAT_FS_DUALNAMES
> > +	bool "VFAT dual names support"
> > +	depends on VFAT_FS
>
> Defaults should be back-compatible.

Hi Pavel,

I disagree with this: given there's been testing with no known issues, it's 
not a back compat question.

I'd actually prefer to see the code ripped out and no config option available; 
it would the clearest avoidance case possible.

I really don't want us to have to do this more than once :(
Rusty.
