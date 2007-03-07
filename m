Return-Path: <linux-kernel-owner+w=401wt.eu-S1161080AbXCGHPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161080AbXCGHPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161092AbXCGHPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:15:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52146 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161080AbXCGHO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:14:59 -0500
Date: Tue, 6 Mar 2007 23:14:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Bryan Wu <bryan.wu@analog.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070306231423.4231c99b.akpm@linux-foundation.org>
In-Reply-To: <20070307075822.53e53c42.khali@linux-fr.org>
References: <1173164058.31825.16.camel@roc-desktop>
	<20070306214301.GA5590@martell.zuzino.mipt.ru>
	<1173247078.28531.24.camel@roc-desktop>
	<20070307075822.53e53c42.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 07:58:22 +0100 Jean Delvare <khali@linux-fr.org> wrote:

> > +config BFIN_SDA
> 
> I2C_BLACKFIN_SDA

The blackfin architecture uses "bfin" pretty much universally, so this
usage is consistent.

box:/usr/src/25> grep -i blackfin patches/blackfin*|wc -l
   1608
box:/usr/src/25> grep -i bfin patches/blackfin*|wc -l
   6198

Let's just hope nobody makes a bluefin.

> > +	range 0 15 if (BF533 || BF532 || BF531) 
> 
> Trailing whitespace.

I always remove that when merging a patch.
