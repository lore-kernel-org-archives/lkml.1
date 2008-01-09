Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbYAILCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbYAILCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYAILCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:02:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:38512 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYAILCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YjPrrskD4OJycQz0rfalZUNAV/TOQIXnsEbxtGrVxY7HN0HzBLbRMyNaSNpeC2Mz2Z0l0G8wyy/KNy+FPUbh1EjqA0O/pY9lSuXPdkGaVIAXaj40knTnBUSmo7tdZrSoOHuJhtfdEkfsUnRQha+zbmMhIAXkOQVaMx4r3KVDsdY=
From: Joonwoo Park <joonwpark81@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>, netdev@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 0/5] iwlwifi: iwl3945 fix races, getting rid of sleep from context
Date: Wed,  9 Jan 2008 20:01:51 +0900
Message-Id: <11998765114113-git-send-email-joonwpark81@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
This patchset does fix iwl3945's races and some other stuff.
For now it works for just iwl3945 but if some of them is needed for iwl4965, I would work for it.

patch against 2.6.24-rc7

[PATCH 1/5] iwlwifi: iwl3945 flush interrupt mask
[PATCH 2/5] iwlwifi: iwl3945 synchronize interrupt and tasklet for down iwlwifi
[PATCH 3/5] iwlwifi: iwl3945 fix oops while pci remove
[PATCH 4/5] iwlwifi: iwl3945 eliminate sleepable task queue from context
[PATCH 5/5] iwlwifi: iwl3945 switch private workqueue to ieee80211->workqueue

Thanks,
Joonwoo
