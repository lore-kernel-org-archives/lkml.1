Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZFGNBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZFGNBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZFGMzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:55:55 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44921 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342AbZFGMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:55:52 -0400
X-Sasl-enc: /B5mjMSMVBIvy/KAadZvKAEglzbrjfkneUeIhZ8D9k8C 1244378559
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 0/2] i386: espfix fixes
Date: Sun,  7 Jun 2009 14:42:34 +0200
Message-Id: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Here are the two patches I said I would send... The first one is a fix 
to include espfix code in the NMI entry/exit code, the second one fixes 
and cleans up the espfix code itself. Tests boots were done using the
tip tree plus both patches.

The first patch applies cleanly to mainline too, and the second has
a trivial reject. I included a patch for mainline too.

Thanks for having a look at them!

Greetings,
	Alexander

 arch/x86/include/asm/desc.h  |   26 -----------------
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/entry_32.S   |   64 +++++++++++++++++++++++++++--------------
 arch/x86/kernel/head_32.S    |    1 -
 arch/x86/kernel/traps.c      |   21 --------------
 5 files changed, 43 insertions(+), 71 deletions(-)
