Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYEEOup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYEEOup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYEEOuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:50:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36760 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbYEEOug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:50:36 -0400
Message-ID: <481F1EB3.3040906@garzik.org>
Date: Mon, 05 May 2008 10:50:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Engelhardt <jengelh@medozas.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0805050735150.32269@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805050735150.32269@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> But my point is, I really want to change just the kernel. I don't want to 
> care what the initrd does, and I don't want to build my own. It's all 
> "user space" to me - and thus beneath my notice.

True, but depending on the distro, the distro may want to load specific 
userland gadgets into the initrd based on your kernel build.

Most kernel hacker situations probably don't need this, but a modern 
distro these days _does_ want critical-to-boot stuff in initrd like LVM 
bootstrap programs, iSCSI discovery, Bluetooth userland management, etc.

	Jeff



