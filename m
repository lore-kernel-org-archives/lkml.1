Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYI3QlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYI3QlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYI3QlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:41:00 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:10771 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYI3QlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:41:00 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 0/4] traps: x86: more unification
Date: Tue, 30 Sep 2008 18:41:33 +0200
Message-Id: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 30 Sep 2008 18:40:41 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.231; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are some more unification patches for traps_xx.c. They
are against the current x86/traps branch in the tip tree and
work fine for my miniconfigs.

The branch does not at the moment compile a defconfig kernel,
due to a missing PCI_DEVICE_ID_AMD_10H_NB_MISC define, however.

Moreover, a defconfig won't run :-/ (on qemu-system-x86_64).
Bisection pointed to commit 10a434fcb "x86: remove cpu_vendor_dev".
The kernel crashes early with a general protection fault in a call
to strnlen. I have no idea what goes wrong, yet.

Greetings,
	Alexander
