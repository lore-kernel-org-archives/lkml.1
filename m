Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYGPAXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYGPAXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYGPAWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:22:45 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:10198 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757941AbYGPAWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:22:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Wed, 16 Jul 2008 02:22:39 +0200
User-Agent: KMail/1.9.9
Cc: david@lang.hm, Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160222.40705.elendil@planet.nl>
X-OriginalArrivalTime: 16 Jul 2008 00:22:41.0047 (UTC) FILETIME=[0F16CA70:01C8E6DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008, Linus Torvalds wrote:
> On Tue, 15 Jul 2008, david@lang.hm wrote:
> > becouse the tools that wrote the initrd already put the modules in. I
> > don't maintain those tools, they came with the distro. we're just
> > asking to not require those tools to be updated immediatly.
>
> But mkinitrd (which is the _only_ thing that people tend to use to
> write initrd's - is there even anything else) has already been doing
> this for years, as has been pointed out several times.

Debian doe not have mkinitrd but initramfs-tools [1] and yaird [2]. The 
status of the last is uncertain (not currently included for Lenny).

Where did you get this strange notion that mkinitrd is the _only_ (your 
emphasis) thing people use?
Point is that I find it really strange that - in the extremely rich and 
varied world that is based on Linux - you seem so certain that every tool 
out there already does the right thing for all cases, or can be trivially 
updated to do so. I just don't believe that.

I even _know_ that yaird is broken wrt. firmware [3]. It's one of the 
reasons it's unlikely to be included in Lenny.

But hell, I'll see if I can give this a try tomorrow. Get out of this 
crazy make-belief discussion and provide some facts. Who knows, maybe 
I'll be surprised and the existing Debian toolsets will do the right 
thing. I seriously doubt it though.

[1] http://packages.debian.org/sid/initramfs-tools
[2] http://packages.debian.org/sid/yaird
[3] Only works if config files are edited manually which makes it useless
    during e.g. new installs.
