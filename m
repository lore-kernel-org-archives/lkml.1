Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZL3Mex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZL3Mex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZL3Mew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:34:52 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60478 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZL3Mev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:34:51 -0500
MIME-Version: 1.0
Date: Wed, 30 Dec 2009 23:34:49 +1100
X-Google-Sender-Auth: 0e267c90476b6bfc
Message-ID: <7574305f0912300434q1bf23b32sf3fb2b6554d79c4c@mail.gmail.com>
Subject: BFS v0.313 CPU scheduler for 2.6.32
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A stupid mismerge in __might_sleep meant that with the right config
options dmesg would have been swamped with false warnings. This also
was making BFS consume a lot of CPU under certain conditions in
combination with preempt RCU.

Thanks to Jayson R King for picking it up!

There are no other changes in this version compared to 312

full patch:
http://ck.kolivas.org/patches/bfs/2.6.32-sched-bfs-313.patch

incremental:
http://ck.kolivas.org/patches/bfs/2.6.32-bfs312-313.patch

I highly recommend BFS users upgrade.

Regards,
--
-ck
