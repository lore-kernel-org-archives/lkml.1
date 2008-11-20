Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYKTLgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYKTLgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYKTLgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:36:12 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54298 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbYKTLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:36:08 -0500
Message-Id: <20081120112543.799450455@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 20:25:43 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [TOMOYO #13 (mmotm 2008-11-19-02-19) 00/11] TOMOYO Linux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.

This patchset is for mmotm 2008-11-19-02-19.

Andrew's comments and our answers on #12 are at
http://lkml.org/lkml/2008/11/6/409
http://lkml.org/lkml/2008/11/10/106
http://lkml.org/lkml/2008/11/10/107
http://lkml.org/lkml/2008/11/11/41
http://lkml.org/lkml/2008/11/17/18 .

How to try:
1. Compile kernel with CONFIG_SECURITY_TOMOYO=y.
2. 'make' and 'make install' userspace tools (ccs-tools) available at
   http://osdn.dl.sourceforge.jp/tomoyo/30298/ .
3. Run /usr/lib/ccs/tomoyo_init_policy.sh .
4. Run following commands to set learning-mode as default.
   (This step is optional but recommended on your first try.)
   # echo '<kernel>' > /etc/tomoyo/domain_policy.conf
   # echo 'use_profile 1' >> /etc/tomoyo/domain_policy.conf
4. Reboot.
   (If you compiled kernel with CONFIG_SECURITY_{SELINUX,SMACK}=y,
    add 'security=tomoyo' to kernel's command line.)
5. Run /usr/sbin/ccs-editpolicy to browse and edit policy.

LiveCD-based tutorials are available at
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/ubuntu8.04-live/
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/centos5-live/ .
Though these tutorials use non-LSM version of TOMOYO,
they are useful for you to know what TOMOYO is.

Regards.
--

