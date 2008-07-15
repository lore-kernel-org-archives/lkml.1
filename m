Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYGOTkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYGOTkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbYGOTjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:39:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757902AbYGOTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:39:53 -0400
Date: Tue, 15 Jul 2008 12:38:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216150288.27242.75.camel@violet.holtmann.net>
Message-ID: <alpine.LFD.1.10.0807151233580.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150288.27242.75.camel@violet.holtmann.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Marcel Holtmann wrote:
> 
> Personally I am against hacking file loading from within the kernel.
> This is why we involved udev (or hotplug in the beginning). It allows
> you to have userspace policy for the search paths etc.

Well, I'm personally against _forcing_ people to use udev. 

Yes, desktop distros generally will do so, since there are lots of complex 
issues etc. But I don't think we've generally forced it on people if they 
don't want it (ie I haven't tried it personally since the distro I used 
started using udev, but I think you can still just ignore udev events and 
set everything up statically).

And I don't think that's wrong. Which implies that setup things should 
still generally at least allow us to avoid udev.

(But maybe I'm wrong, and everybody already uses udev just because they 
couldn't be bothered not to).

			Linus
