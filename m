Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbYKDGJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbYKDGJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKDGJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:09:39 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:46006 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYKDGJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:09:38 -0500
Message-Id: <20081104060847.086543472@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Tue, 04 Nov 2008 15:08:47 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Toshiharu Harada <haradats@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [TOMOYO #12 (2.6.28-rc2-mm1) 00/11] TOMOYO Linux
X-OriginalArrivalTime: 04 Nov 2008 06:09:33.0848 (UTC) FILETIME=[E8567180:01C93E43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is a pathname-based MAC extension (LSM module) for the 
Linux kernel.

This patchset is for 2.6.28-rc2-mm1.

Serge Hallyn wrote:
> Well I think the patchset is at a stage where it needs a test-spin in
> -mm (or something).
All right. ;-)
Andrew, please put this patchset to -mm.

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
    add 'security=tomoyo' to kernel cmdline.)

Run ccs-editpolicy to browse and edit policy. LiveCD-based tutorials 
are available at
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/ubuntu8.04-live/
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/centos5-live/ .
Though these tutorials use non-LSM version of TOMOYO, they are useful 
for you to know what TOMOYO is.

Regards,
--

