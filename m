Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYEEPcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYEEPcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYEEPcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:32:46 -0400
Received: from testure.choralone.org ([194.9.77.134]:38741 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYEEPcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:32:46 -0400
Date: Mon, 5 May 2008 11:32:30 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
Message-ID: <20080505153230.GA25704@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Jan Engelhardt <jengelh@medozas.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
	Jon Masters <jonathan@jonmasters.org>,
	Sam Ravnborg <sam@ravnborg.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 08:43:06AM +0200, Jan Engelhardt wrote:
 
 > So it's like:
 > 	<hack hack hack>
 > 	make modules_install
 > 	cp arch/x86/boot/bzImage /boot/mykernel
 > 	cp System.map /boot/System.map-2.6.26.1
 > 	mkinitrd -i /boot/myinitrd -k /boot/mykernel # suse, fedora might slightly different

For Fedora (and many other distros), you can replace the last three lines with 'make install'
It'll do everything. Construct the initrd. Install it & the vmlinuz, point grub.conf at it. etc.

	Dave

-- 
http://www.codemonkey.org.uk
