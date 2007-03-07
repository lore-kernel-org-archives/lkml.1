Return-Path: <linux-kernel-owner+w=401wt.eu-S1161157AbXCGHjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157AbXCGHjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161204AbXCGHjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:39:23 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:9236 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161157AbXCGHjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:39:22 -0500
X-IronPort-AV: i="4.14,256,1170651600"; 
   d="scan'208"; a="30231746:sNHT22919295"
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, Bryan Wu <bryan.wu@analog.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
In-Reply-To: <20070306231423.4231c99b.akpm@linux-foundation.org>
References: <1173164058.31825.16.camel@roc-desktop>
	 <20070306214301.GA5590@martell.zuzino.mipt.ru>
	 <1173247078.28531.24.camel@roc-desktop>
	 <20070307075822.53e53c42.khali@linux-fr.org>
	 <20070306231423.4231c99b.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 07 Mar 2007 15:39:27 +0800
Message-Id: <1173253167.28531.41.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 23:14 -0800, Andrew Morton wrote:
> On Wed, 7 Mar 2007 07:58:22 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> 
> > > +config BFIN_SDA
> > 
> > I2C_BLACKFIN_SDA
> 
> The blackfin architecture uses "bfin" pretty much universally, so this
> usage is consistent.
> 
> box:/usr/src/25> grep -i blackfin patches/blackfin*|wc -l
>    1608
> box:/usr/src/25> grep -i bfin patches/blackfin*|wc -l
>    6198
> 

Thanks for you understanding, but now we want to move to use
CONFIG_BLACKFIN options. There is a new task in our development plan to
change things to CONFIG_BLACKFIN.

At this moment, we both provide CONFIG_BFIN and CONFIG_BLACKFIN. When
all the things relied on CONFIG_BFIN/bfin are changed to
CONFIG_BLACKFIN/blackfin, the CONFIG_BFIN will be removed.

So here I will follow Jean's comments.

> Let's just hope nobody makes a bluefin.

So it is ok  for both blackfin and bluefin. But I think Black is cooler
than Blue. -:)

> 
> > > +	range 0 15 if (BF533 || BF532 || BF531) 
> > 
> > Trailing whitespace.
> 
> I always remove that when merging a patch.

Thanks a lot, could you please give me a script just to kill this
whitespace? So I can do it before sending you patches.

Thanks Jean and Andrew.
-Bryan
