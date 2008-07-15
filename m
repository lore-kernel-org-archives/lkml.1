Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbYGOTop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbYGOTop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGOToh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:44:37 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55408 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYGOToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:44:37 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151233580.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	 <1216150288.27242.75.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151233580.3351@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:44:45 +0200
Message-Id: <1216151085.27242.86.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > Personally I am against hacking file loading from within the kernel.
> > This is why we involved udev (or hotplug in the beginning). It allows
> > you to have userspace policy for the search paths etc.
> 
> Well, I'm personally against _forcing_ people to use udev. 
> 
> Yes, desktop distros generally will do so, since there are lots of complex 
> issues etc. But I don't think we've generally forced it on people if they 
> don't want it (ie I haven't tried it personally since the distro I used 
> started using udev, but I think you can still just ignore udev events and 
> set everything up statically).
> 
> And I don't think that's wrong. Which implies that setup things should 
> still generally at least allow us to avoid udev.
> 
> (But maybe I'm wrong, and everybody already uses udev just because they 
> couldn't be bothered not to).

I actually think that is the case here. udev is so lightweight and
really slim nowadays that not using it is a big drawback. There might be
some system out there that are still using a static /dev directory, but
for sure there are not many and even the embedded world doesn't really
mind.

Also I think the /sbin/hotplug thing is still available (not verified
this) and thus calling a firmware loading helper script with a udev
replacement would be possible. Someone correct me here if I am wrong.

Regards

Marcel


