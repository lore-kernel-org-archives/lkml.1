Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYA1IVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYA1IVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYA1IVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:21:35 -0500
Received: from aun.it.uu.se ([130.238.12.36]:34226 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYA1IVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:21:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18333.37002.749771.524523@harpo.it.uu.se>
Date: Mon, 28 Jan 2008 09:21:30 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: Wake On Lan in sky2 broken on Mac mini
In-Reply-To: <20080128002934.GA6354@dose.home.local>
References: <20080128002934.GA6354@dose.home.local>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel writes:
 > Hi folks,
 > 
 > with 2.6.24-rc8, Wake On LAN doesn't work anymore as it used to with
 > 2.6.23 on my Mac mini Core Duo. I saw that this was reported in
 > http://bugzilla.kernel.org/show_bug.cgi?id=9721 and on netdev a patch
 > for the sky2 driver was sent by Stephen Hemminger. This patch fixed WOL
 > for me after applying it to 2.6.24-rc8.
 > 
 > However, it seems as the patch never made it into the kernel. Instead,
 > the commit that was suspected to break WOL
 > (84cd2dfb04d23a961c5f537baa243fa54d0987ac) was reverted
 > (be63a21c9573fbf88106ff0f030da5974551257b).
 > 
 > Now I tried the 2.6.24 release and noticed that WOL is still broken.
 > I'll be happy to test any patches that can make it into 2.6.24.1.

1. Wrong mailing list; use netdev (@vger) instead.
2. The reverted commit had much much more serious consequences than
   "wol doesn't work", it actually caused BIOS hangs and failed reboots.
