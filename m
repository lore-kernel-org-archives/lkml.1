Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbXFXV5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbXFXV5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXFXV46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:56:58 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:40568 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751352AbXFXV46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:56:58 -0400
X-Greylist: delayed 1094 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jun 2007 17:56:58 EDT
Message-ID: <467EE48D.5010204@arndnet.de>
Date: Sun, 24 Jun 2007 23:39:25 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Salvatore De Paolis <depaolis.salvatore@libero.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pivot_root alternative
References: <20070624232734.28829225@debian> <Pine.LNX.4.64.0706242328520.11964@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706242328520.11964@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt schrieb:
> On Jun 24 2007 23:27, Salvatore De Paolis wrote:
>> i built the kernel with a busybox initramfs which runs from a usb stick. While
>> i boot i need to mount the real root and i'm using pivot_root.
>> Pivot_root . old-root return to me an "Invalid argument" error and googling i
>> found here http://lkml.org/lkml/2005/10/8/17 that pivot_root should be avoided.
>> I want to ask now what i should do to switch to a real root?
> 
> use run-init from klibc?

However be aware of the limitation of run-init:
It only works for direct childs of root directory
/mnt/newroot won't work
/newroot should work ;-)

Good luck,
Arnd
