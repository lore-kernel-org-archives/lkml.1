Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128Ab0AUQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0AUQl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867Ab0AUQlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:41:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38383 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0AUQlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:41:23 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 0/7] x86, cacheinfo, amd: L3 Cache Index Disable fixes
Date: Thu, 21 Jan 2010 17:41:26 +0100
Message-Id: <1264092093-13739-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Changelog:

-v2: Split smp functionality into a different module


===
these are a bunch of fixes which correct the disabling of L3 cache
indexes. This is needed, for example, in the case when excessive
correctable L3 error rates are observed. In a later step, this
functionality will be connected to the mcheck mechanism and used to
evaluate occurring L3 tag and data array errors and then disable the
respective failing L3 cache regions in order to defer system failure
before a sysop can intervene.

Those patches are also good -stable candidates.

Please apply,
thanks.
