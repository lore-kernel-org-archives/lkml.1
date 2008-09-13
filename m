Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYIMT3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYIMT3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYIMT24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:28:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:3787 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYIMT2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PtlD0FMLazIIMiwL8aHLoMNGnLPlDHA8JTYYJu5+uwM33dDjtWzap5fp2AZ+4Q6Fge
         sgqkPQaMpnm9oktxUB4El7Tucf95mcBGD/My+XXREbLiwY+rfOG9MAeZxukkTU3rarnJ
         fA0Sn1PGFfv9on+Ob6tVse5eJZ5rzhPfNy02s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/3] acpi/x86: __apci_unmap_table and early_ioremap cleanup v3
Date: Sat, 13 Sep 2008 12:28:18 -0700
Message-Id: <1221334101-6464-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the map/unmap and nesting requirement.
and early acpi tables could map more table at same time if needed.
also could unmap them out of order.

YH
