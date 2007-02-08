Return-Path: <linux-kernel-owner+w=401wt.eu-S1423220AbXBHQhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423220AbXBHQhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423222AbXBHQhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:37:24 -0500
Received: from mail.tmr.com ([64.65.253.246]:37498 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423220AbXBHQhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:37:23 -0500
Message-ID: <45CB4C01.2060709@tmr.com>
Date: Thu, 08 Feb 2007 11:12:49 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20: Modular fb and logo crash
References: <Pine.LNX.4.62.0702071521340.29060@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0702071521340.29060@pademelon.sonytel.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> If you don't have any builtin frame buffer device driver and insmod a frame
> buffer device driver, the logo code will still try to display the logo (which
> is __initdata). This may cause a crash.
> 
> Originally (2.1.x, is it that long ago I used a modular frame buffer device
> driver?), this didn't happen because initmem_freed (which no longer exists) was
> checked. BTW, there's still a comment in drivers/video/console/fbcon.c about
> this.
> 
> Anyone else who's seeing this? Anyone with an idea how to fix this?
> Moving the logo code to userspace is not considered a solution ;-)

I used to see this when loading from a booted system, but not when the 
modules were in initrd. Don't know if that offers you any help or not. 
Clearly you want the fb built-in so you see the penguins, anyway. ;-D

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

