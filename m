Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYI3LLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYI3LLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYI3LLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:11:41 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:24021 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYI3LLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:11:40 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 0/2] x86: split out dumpstack code from traps_xx.c
Date: Tue, 30 Sep 2008 13:12:13 +0200
Message-Id: <1222773135-1073-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 30 Sep 2008 13:11:20 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.227; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I intend to keep looking for possibilities to bring traps_32.c
and traps_64.c closer to each-other. One trivial way (from my
point of view) is to split out code into separate files. These
two patches split out a large piece of code that has nothing to
do with hardware traps. Are you willing to take those two
patches? Or are they to intrusive?

Patches are against the current master branch of the tip tree.
The defconfigs compile fine and I ran some simple configs within
qemu.

Greetings,
	Alexander
