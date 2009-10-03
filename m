Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZJCRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZJCRT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZJCRT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:19:58 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:46782 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZJCRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:19:58 -0400
From: manfred@colorfullife.com
To: linux-kernel@vger.kernel.org
Cc: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/7] ipc/sem.c: Performance updates
Date: Sat,  3 Oct 2009 19:19:20 +0200
Message-Id: <1254590364-2876-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.2.5
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>

[2nd sending due to hitting TABOO. I've switched to git-send-email now.
The patches 1, 2, 3 went to the list on thursday/friday]

Around a month ago, there was some discussion about an improvement
of the sysv sem algorithm:
Most (at least: some important) users only use simple semaphore operations,
therefore it's worthwile to optimize this use case.

The first three patches are from Nick, the remaining 4 patches are from
myself.

The patches are tested, and IMHO ready widespread testing/merging.

Andrew: As far as I can see, there is no maintainer for ipc.
Could you add the patches to -mm and forward them to Linus
afterwards?

--
	Manfred
