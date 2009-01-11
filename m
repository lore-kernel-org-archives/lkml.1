Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZAKWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZAKWGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZAKWF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:05:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50293
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbZAKWF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:05:58 -0500
Date: Sun, 11 Jan 2009 14:05:59 -0800 (PST)
Message-Id: <20090111.140559.126980927.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1231711347.25018.658.camel@macbook.infradead.org>
References: <1231676698.25018.147.camel@macbook.infradead.org>
	<20090111.133929.57600645.davem@davemloft.net>
	<1231711347.25018.658.camel@macbook.infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Sun, 11 Jan 2009 22:02:27 +0000

> On Sun, 2009-01-11 at 13:39 -0800, David Miller wrote:
> > For example, for mounting an NFS root using that device.... Oh, will I
> > need an initramfs for that once you pull the firmware-in-kernel
> > option?
> 
> The option to build arbitrary firmware into your kernel is never going
> to be pulled. You can do nfsroot on your myri10ge today, without initrd,
> even though the firmware is distributed separately from the kernel. That
> doesn't prevent you from building it _in_ to your kernel, if you choose
> to.

So what used to work out of the box by typing make now
will have all kinds of strange depencies, right?

This is a regression, no matter how you spin it, in my
book.
