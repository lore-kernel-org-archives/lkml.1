Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbZAHUxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbZAHUxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZAHUxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:53:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49341
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbZAHUx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:53:29 -0500
Date: Thu, 08 Jan 2009 12:53:31 -0800 (PST)
Message-Id: <20090108.125331.03608787.davem@davemloft.net>
To: alessandro.suardi@gmail.com
Cc: jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, dwmw2@infradead.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <5a4c581d0901081233y6b546167sbe3ed9f2ea37f1f9@mail.gmail.com>
References: <5a4c581d0901070624t6e769966t6b034b14d4732bd@mail.gmail.com>
	<3f9a31f40901072212x41e405fh7e36f6adb927814b@mail.gmail.com>
	<5a4c581d0901081233y6b546167sbe3ed9f2ea37f1f9@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Date: Thu, 8 Jan 2009 21:33:35 +0100

> On Thu, Jan 8, 2009 at 7:12 AM, Jaswinder Singh Rajput
> <jaswinderlinux@gmail.com> wrote:
> > Hello alessandro,
> >
> > On Wed, Jan 7, 2009 at 7:54 PM, Alessandro Suardi
> > <alessandro.suardi@gmail.com> wrote:
> >>
> >> Note that I don't have CONFIG_FIRMWARE_IN_KERNEL, but on
> >>  the other hand I didn't earlier, either... and yes, CONFIG_MODULES=y.
> >>
> >
> > Please try with CONFIG_FIRMWARE_IN_KERNEL , is this makes some difference.
> 
> Yes it does, thank you - 2.6.28-git11 with CONFIG_FIRMWARE_IN_KERNEL
>  gets my tg3 back to work on boot. Must be a requirement since -git8 then ?

It is if you don't have the tg3 firmware files in your filesystem
already.
