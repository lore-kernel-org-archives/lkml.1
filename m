Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYC2STd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYC2STd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYC2ST0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:19:26 -0400
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:43631 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYC2STZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:19:25 -0400
Message-ID: <47EE8829.10409@the2masters.de>
Date: Sat, 29 Mar 2008 19:19:21 +0100
From: Stefan Hellermann <stefan@the2masters.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20080218)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: make O=dir fails with current git
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using "make O=machinename" for building different kernels from one tree. About 15 days
ago it was okay, with current git it fails:
$ make O=client1
scripts/kconfig/conf -s arch/x86/Kconfig
  Using /srv/devel/kernel as source for kernel
  /srv/devel/kernel is not clean, please run 'make mrproper'
  in the '/srv/devel/kernel' directory.
make[1]: *** [prepare3] Error 1
make: *** [sub-make] Error 2

running "make mrproper" (without O=dir) doesn't help.
I've not changed anything, I only made a "git-pull".
Now I'm at home, tried "mkdir test; make O=test defconfig all" with current git-head, it
doesn't work too.

Stefan


