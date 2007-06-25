Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbXFYEAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbXFYEAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXFYEAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:00:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXFYEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:00:11 -0400
Message-ID: <467F3DA8.8030908@zytor.com>
Date: Sun, 24 Jun 2007 20:59:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Salvatore De Paolis <depaolis.salvatore@libero.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pivot_root alternative
References: <20070624232734.28829225@debian> <Pine.LNX.4.64.0706242328520.11964@fbirervta.pbzchgretzou.qr> <467EE48D.5010204@arndnet.de>
In-Reply-To: <467EE48D.5010204@arndnet.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Hannemann wrote:
> Jan Engelhardt schrieb:
>> On Jun 24 2007 23:27, Salvatore De Paolis wrote:
>>> i built the kernel with a busybox initramfs which runs from a usb stick. While
>>> i boot i need to mount the real root and i'm using pivot_root.
>>> Pivot_root . old-root return to me an "Invalid argument" error and googling i
>>> found here http://lkml.org/lkml/2005/10/8/17 that pivot_root should be avoided.
>>> I want to ask now what i should do to switch to a real root?
>> use run-init from klibc?
> 
> However be aware of the limitation of run-init:
> It only works for direct childs of root directory
> /mnt/newroot won't work
> /newroot should work ;-)
> 

Hm, that should probably be fixed.  It should be able to work on any
directory as long as there isn't another *filesystem* involved...

	-hpa
