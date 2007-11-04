Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbXKDMkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbXKDMkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbXKDMko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:40:44 -0500
Received: from rex96.flatbooster.net ([83.133.189.96]:48922 "EHLO
	rex96.flatbooster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbXKDMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:40:43 -0500
X-Greylist: delayed 2082 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2007 07:40:43 EST
Message-ID: <472DB5A5.4030308@bernd-steinhauser.de>
Date: Sun, 04 Nov 2007 13:05:57 +0100
From: Bernd Steinhauser <linux@bernd-steinhauser.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070909)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at mm/slab.c:3006
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

today I ran into a kernel bug when I ran 'rc-update add xdm default' on
gentoo. See:
http://img339.imageshack.us/img339/6486/dsc00042gy1.jpg

Kernel is 2.6.24-rc1 from Nigel Cunningham's tuxonice tree. Latest
commit from git
log was d51f219edfdba30db26dbfd27cd7ca6a11c140d9.
Unfortunately I couldn't reproduce it (directly after the boot process I
logged in and
wanted to add X to default runlevel, logout and login as a normal user,
I did the same
thing again, but it didn't happen again.) and it only happened once.
Therefore I don't know if this was already present in earlier kernels.

Greetings,
Bernd
