Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYBGNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYBGNGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYBGNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:06:06 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34780 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYBGNGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:06:03 -0500
Message-ID: <47AB0238.5030400@davidnewall.com>
Date: Thu, 07 Feb 2008 23:36:00 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se> <20080203231530.GB15692@kroah.com> <courier.47A8EDDC.0000785F@hawking.rebel.net.au> <47A8F27F.3060504@nortel.com>
In-Reply-To: <47A8F27F.3060504@nortel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> if I were to write a new GPL shim and then a new closed-source module
> that uses the shim to access kernel symbols, it is entirely possible
> that a court could rule that my closed-source module is a derivative
> work of the linux kernel because it was written specifically to run on
> linux.

A lot of software is written specifically to run on Linux, but that
doesn't mean it's derived from Linux.  In the case of user-space code
it's widely understood that no licence restrictions are conferred.  The
argument relating to kernel modules is that a module is somehow
different because it runs in kernel mode.  I can't see it, and in view
of the status of user-space code, strong arguments would have to be made.
>
> On the other hand if I were to sit down and write an OS-agnostic
> proprietary chunk of code, and then write a new GPL shim to use it
> under linux (and maybe other shim layers for other OS's as well), I
> _might_ be okay.  But I would have to be prepared to prove that the
> proprietary code was not derived from the Linux kernel.

No.  Holders of Linux copyrights would have to prove that the
proprietary code is derived from the kernel.  They have the burden of
proof, and defence needs merely show that their arguments are wrong. 
(So if the proof is faulty, the case fails even if the code is derivative.)
