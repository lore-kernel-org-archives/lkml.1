Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYDUJQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYDUJQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYDUJQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:16:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35803 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYDUJQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:16:46 -0400
Date: Mon, 21 Apr 2008 12:15:40 +0300 (EEST)
Message-Id: <20080421.121540.84605023.Hiroshi.DOYU@nokia.com>
To: dbaryshkov@gmail.com
Cc: paul@pwsan.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       haavard.skinnemoen@atmel.com, rmk+lkml@arm.linux.org.uk,
       lethal@linux-sh.org, philipp.zabel@gmail.com, pavel@ucw.cz,
       tony@atomide.com, david-b@pacbell.net
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
References: <20080420082925.GA32739@doriath.ww600.siemens.net>
	<alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com>
	<bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 09:15:45.0231 (UTC) FILETIME=[479F75F0:01C8A390]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

From: "ext Dmitry" <dbaryshkov@gmail.com>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Date: Mon, 21 Apr 2008 12:48:24 +0400

> >  - Hiroshi DOYU has proposed an alternate debugfs implementation for the
> >   Linux-OMAP clock tree.  I prefer it to yours, as it implements each
> >   clock as a separate dentry, which makes it easy to implement additional
> >   debugging functions, such as set_rate/set_parent/round_rate debugging.
> >   Perhaps you'd consider it, or something similar to it, instead?  It is
> >   proposed here:
> >      http://www.mail-archive.com/linux-omap@vger.kernel.org/msg00751.html
> 
> I'll look at this. However, if we are going to use such
> implementation, may we should
> move instead to sysfs?

This has been discussed within the above thread in omap and you can
find the sysfs implementation sysfs at the bottom of the following:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg00696.html

    Hiroshi DOYU
