Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXCaUtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXCaUtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXCaUtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:49:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbXCaUtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:49:42 -0400
Date: Sat, 31 Mar 2007 13:46:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen.Clark@seclark.us
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Francois Romieu <romieu@fr.zoreil.com>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.21-rc5 from fc7-rc2 problems
Message-Id: <20070331134610.64a9c410.akpm@linux-foundation.org>
In-Reply-To: <460EC109.5070300@seclark.us>
References: <460EC109.5070300@seclark.us>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 16:14:01 -0400 Stephen Clark <Stephen.Clark@seclark.us> wrote:

> Hello,
> 
> I have just tried booting the fc7-rc2 live cd on 2 of my laptops and it 
> failed on both.
> 
> Laptop 1 is an asus vbi s96f that get a panic that says exception in 
> interrupt routine
> for my rtl8139.
>
> This device works fine in 2.6.20.2

That's regression #1.  Are you able to take a photograph of the screen
when it has crashed?  Setting the display to 50 rows would make that more
useful.  (serial console would be better, but I assume that thing has
no serial port).

> 
> The other laptop is a hp n5430 it fail in the ali-pata driver not being 
> able to read the cdrom, timeing out
> and dropping into a bash shell telling me to tell it where the root 
> filesystem is.

That's #2, I guess.

> Also it sets my hard
> drive to udma/33 when it run find at udma/66 under 2.6.20.1.

#3.  Hopefully it's related to #2.

Please send the full dmesg output for 2.6.20.1 on the n5430.

> It would 
> really be nice if the people makeing
> all these changes would at least keep things compatible with what they 
> were before. These are regressions
> guys!

We try ;)

> This hp n5430 system works fine with 2.6.20.1.

Thanks, it helps.

