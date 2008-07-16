Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYGPICx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYGPICx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYGPICj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:02:39 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:47896 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYGPICh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:02:37 -0400
Date: Wed, 16 Jul 2008 10:02:35 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel,  use it in more drivers.
Message-ID: <20080716080235.GB11485@boogie.lpds.sztaki.hu>
References: <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu> <487CF70C.1030309@garzik.org> <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org> <487D1327.7090805@garzik.org> <alpine.LFD.1.10.0807151420550.2867@woody.linux-foundation.org> <487D1925.50008@garzik.org> <1216159959.26991.48.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807160241060.21568@mercury.sdinet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807160241060.21568@mercury.sdinet.de>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 02:55:32AM +0200, Sven-Haegar Koch wrote:

> Something from the non-development world:
> 
> At least the initramfs-tools (which contains mkinitrd) of Debian Etch do 
> not do this (the current testing/development version Lenny does) - no 
> firmware support in the initrd at all - and not needed for booting until 
> now.
> (It has /lib/firmware support after the initrd for the not-so-important
> stuff like usb/sound/video/wireless)
> 
> Yes, it may be nearly ancient by now, but for servers it contains all we 
> need, and most certainly would not want to use something that changes and 
> needs checking/hand-fixing every month - I expect this version to be still 
> in use a year from now, then just gradually being updated to the next 
> debian version.
> 
> Currently we use 2.6.24, and I expect to use some newer kernel to support 
> newer replacement hardware before all installs are upgraded. So having the 
> firmware-inside-module support would be a help for us when modules are 
> starting to be needed for disk or network access, keeping from the need to 
> try backporting huge initrd/make-kpkg changes.

You can easyly install initramfs-tools from lenny on an etch box. It
only depends on a newer klibc, so it won't disturb any other services.

Btw., the Debian-provided 2.6.25 kernel already lacks the firmware for
some popular modules (like bnx2). So if you're using Debian, you as a
sysadmin already have to handle the "firmware is in a separate package"
issue.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
