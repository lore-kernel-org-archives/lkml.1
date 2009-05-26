Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbZEZX5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbZEZX5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbZEZXyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZEZXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:43 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Subject: x86 MCE improvements series for 2.6.31 v2
Date: Wed, 27 May 2009 01:54:02 +0200
Message-Id: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various new Intel x86 machine check features, including initial support
for machine check recovery and new status bits. The actual machine check
recovery requires some generic VM changes, which will be posted in a separate
series ("POISON series"), however this series is independent and compiles
without it.

This is all ready for merging for 2.6.31. 

v2: Various bug fixes and a few minor improvements
Now based on the mce3-32bitmerge branch
(git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce3-32bitmerge)
which is based on the mce3 branch
(git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce3)
which is a updated version of the x86/mce2 branch in tip

-Andi


