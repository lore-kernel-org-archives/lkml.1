Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZAAFVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZAAFVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 00:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZAAFUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 00:20:44 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58112 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZAAFUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 00:20:43 -0500
Message-Id: <20090101050741.372438529@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 2009 14:07:41 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [TOMOYO #14 (mmotm 2008-12-30-16-05) 00/10] TOMOYO Linux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happy new year!

TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.

The security_path_* LSM hooks have just got merged into Linus's git tree!
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=be6d3e56a6b9b3a4ee44a0685e39e595073c6f0d

Now, it's time to repost #13.
This patchset is for mmotm 2008-12-30-16-05 .

How to try:
1. Compile kernel with CONFIG_SECURITY_TOMOYO=y.
2. 'make' and 'make install' userspace tools (ccs-tools) available at
   http://sourceforge.jp/projects/tomoyo/releases/30298/ .
3. Run /usr/lib/ccs/tomoyo_init_policy.sh .
4. Run following commands to set learning-mode as default.
   (This step is optional but recommended on your first try.)
   # echo '<kernel>' > /etc/tomoyo/domain_policy.conf
   # echo 'use_profile 1' >> /etc/tomoyo/domain_policy.conf
5. Reboot.
   (If you compiled kernel with CONFIG_SECURITY_{SELINUX,SMACK}=y,
    add 'security=tomoyo' to kernel's command line.)
6. Run /usr/sbin/ccs-editpolicy to browse and edit policy.

LiveCD-based tutorials are available at
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/ubuntu8.04-live/
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/centos5-live/ .
Though these tutorials use non-LSM version of TOMOYO,
they are useful for you to know what TOMOYO is.

Regards.

