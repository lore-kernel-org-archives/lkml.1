Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYDAX7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYDAX7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYDAX6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:58:50 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:64018 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbYDAX6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:58:48 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] [MIPS] unexport a few symbols in MIPS-specific code
Date: Wed,  2 Apr 2008 03:58:33 +0400
Message-Id: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

A few exported symbols in MIPS-specific code can be unexported,
and this series of patches does so.

This series was tested using a custom config that was produced
by running `make allmodconfig', after which the CONFIG_VORTEX
option was manually turned off. The patches I am submitting do
not touch the code affected by this option, however. Setting
this options on leads to unbuildable kernel independently of
whether the patches are applied.

Additionally, the entire patchset was tested at runtime by
booting the Malta 4Kc board up to the shell prompt and
inserting the `oprofile.ko' kernel module. The tests were
successful.

Thanks,
Dmitri
