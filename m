Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbYA1A3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbYA1A3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 19:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYA1A3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 19:29:30 -0500
Received: from eazy.amigager.de ([213.239.192.238]:56914 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYA1A33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 19:29:29 -0500
Date: Mon, 28 Jan 2008 01:29:34 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 regression: Wake On Lan in sky2 broken on Mac mini
Message-ID: <20080128002934.GA6354@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

with 2.6.24-rc8, Wake On LAN doesn't work anymore as it used to with
2.6.23 on my Mac mini Core Duo. I saw that this was reported in
http://bugzilla.kernel.org/show_bug.cgi?id=9721 and on netdev a patch
for the sky2 driver was sent by Stephen Hemminger. This patch fixed WOL
for me after applying it to 2.6.24-rc8.

However, it seems as the patch never made it into the kernel. Instead,
the commit that was suspected to break WOL
(84cd2dfb04d23a961c5f537baa243fa54d0987ac) was reverted
(be63a21c9573fbf88106ff0f030da5974551257b).

Now I tried the 2.6.24 release and noticed that WOL is still broken.
I'll be happy to test any patches that can make it into 2.6.24.1.

Regards,
Tino
