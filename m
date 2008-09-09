Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYIIUzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYIIUzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYIIUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:55:04 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:12286 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYIIUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:55:03 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [RFC/PATCH] i386: handle all exceptions with interrupts off initially
Date: Tue,  9 Sep 2008 21:55:54 +0200
Message-Id: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 09 Sep 2008 21:55:30 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

x86_64 handles all exceptions with interrupts off initially, this
bisectable patch set does the same for i386, in (very) small steps.
If this is acceptable, it would make further unification of traps_32.c
and traps_64.c a lot easier. If it is not... why?

Patches are against current -git.

Every step in the series runs fine in a simple system under qemu.

Greetings,
	Alexander
