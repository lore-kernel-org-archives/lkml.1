Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYAYVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYAYVuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYAYVuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:50:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbYAYVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:50:24 -0500
Date: Fri, 25 Jan 2008 13:49:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jon Masters <jonathan@jonmasters.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
In-Reply-To: <1201296027.32422.80.camel@perihelion>
Message-ID: <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org>
References: <20080125071127.GA4860@kroah.com>  <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>  <20080125185213.GA23475@suse.de>  <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>  <479A3ED3.6020808@goop.org>
 <1201296027.32422.80.camel@perihelion>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jan 2008, Jon Masters wrote:
> 
> Right. I assumed that Linus was calling mkinitrd but was being bitten by
> one of the occasional assumptions (I believe we make in that script)

No. I really am not. My /etc/grub.conf looks like this:

	title Linux
	        root (hd0,0)
	        kernel /vmlinuz ro root=/dev/VolGroup00/LogVol00 rhgb quiet
	        initrd /initrd-2.6.23.14-107.fc8.img

ie I literally run the fedora initrd.

I switch kernels, not initrd's. I don't even want to know if the initrd 
contains some distro-specific setup...

		Linus
