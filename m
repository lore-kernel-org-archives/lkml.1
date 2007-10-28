Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXJ1D3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXJ1D3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXJ1D3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:29:33 -0400
Received: from ro-out-1112.google.com ([72.14.202.176]:38245 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbXJ1D3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=rzzy/M1s2W0u7oX4MX0Q4c0GvxMXtegB+PZp3OT/FNB5YlxOF13OIjYuccQHPTvDw6M3MJaFZcsxKkNDkozDE9lpcmR2sp9p2bps688Zevpwddj4usFBxgeRaaCvey7JY5db901YMCeykd4vy6hxwSQVZ6uaraxv6odpyL8cfZE=
Date: Sun, 28 Oct 2007 11:24:41 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jdike@karaya.com, user-mode-linux-devel@lists.sourceforge.net,
       sam@ravnborg.org
Subject: UML building failed in current Linus-tree
Message-ID: <20071028032441.GB2502@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Jeff, Sam!

I just pulled from Linus-tree, and got the following error when building uml.

$ make defconfig ARCH=um
/home/wangcong/projects/linux-2.6/arch/um/Makefile-i386:32: /home/wangcong/projects/linux-2.6/arch/i386/Makefile.cpu: No such file or directory
make: *** No rule to make target `/home/wangcong/projects/linux-2.6/arch/i386/Makefile.cpu'.  Stop.

Is this a known problem? Yesterday's Linus-tree was fine.

Regards.

-- 
May the Source Be With You.
