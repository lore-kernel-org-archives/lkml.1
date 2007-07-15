Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbXGOKl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbXGOKl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbXGOKlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:41:20 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:53164 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611AbXGOKlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:41:19 -0400
Message-ID: <4699F9CB.5010407@arcor.de>
Date: Sun, 15 Jul 2007 12:41:15 +0200
From: Timo Lindemann <tlindemann@arcor.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel hang in ohci init
References: <4695EC25.6050003@arcor.de> <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com> <200707122040.36800.david-b@pacbell.net>
In-Reply-To: <200707122040.36800.david-b@pacbell.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Thursday 12 July 2007, Satyam Sharma wrote:
> 
> Note that hangs in that file almost always mean "your BIOS is goofy".
> Hunt for BIOS settings related to USB, and change them. 
This laptop's BIOS only offers "legacy support" enabled or disabled,
both of which lead to frozen kernel. I will investigate whether the GIT
tree freezes at the same point.

>>> after this, kernel apparently goes into busy waiting (fans gradually
>>> turn louder) and hangs indefinitely. I have also made sure that writel
>>> (in linux/include/asm/io.h) really is entered, but never returns.
> 
> Does the current kernel.org GIT tree do the same thing?  A bunch
> of USB patches were recently merged, including ISTR one in that
> area ...
It does the same thing, git5, that is. Sorry I took so long, but I didnt
get to testing this earlier.

It is just odd that up to (not including) the 2.6.21-series every kernel
boots, and after that, they just freeze.

I am kinda stumped here.

Regards
TL
-- 
