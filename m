Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbYDPLOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbYDPLOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 07:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYDPLOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 07:14:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49430 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbYDPLON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:14:13 -0400
Date: Wed, 16 Apr 2008 13:14:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>
Subject: Re: RFC: Self-snapshotting in Linux
Message-ID: <20080416111412.GB32432@atrey.karlin.mff.cuni.cz>
References: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry if this is a a crazy idea.....just be forewarned....
> 
> First, I would like to make a reference to VMWare's snapshot (name not
> important, emphasize the idea) feature - hopefully u are familiar with
> it.   This is a feature whereby u can freeze the entire OS (kernel +
> userspace application running) and then later reload itself next time,
> continuing where it left off, without reboot from ground zero.
> 
> Next, can I ask, is such a feature useful in Linux?   Ie, able to
> restart the kernel + userspace application from where u left off, the
> last time round.    Not JUST the normal suspend/resume feature, but
> more important able to CHOOSE among the different available images
> for
> u to resume on.   Eg, u want to freeze the current 2.6.25-rc6
> kernel,

Could we use english on this list?

Anyway, hibernate, cp /dev/root /somewhere/root.1; cp /dev/swap
/somewhere/swap.1

If you want to resume selected version, copy back that set of devices,
and proceed normally.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
