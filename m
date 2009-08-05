Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZHELTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZHELTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZHELTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:19:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41941 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZHELTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:19:45 -0400
Date: Wed, 5 Aug 2009 07:19:02 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
Subject: [Patch 0/7] Implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series of patch implements automatically reserved memory for crashkernel,
by introducing a new boot option "crashkernel=auto". This idea is from Neil.

In case of breaking user-space applications, it modifies this boot option after
it decides how much memory should be reserved.

On different arch, the threshold and reserved memory size is different. Please
refer patch 7/7 which contains an update for the documentation.

Note: This patchset was only tested on x86_64 with differernt memory sizes.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>

