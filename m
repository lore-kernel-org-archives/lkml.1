Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYHQTm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYHQTm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHQTlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11381 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYHQTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n4W+FMY2b8wFESzeiOOxW2cu7R77V/K2HPnbwJqjb5LkDj6K3xK6/iWSMitQ7n2H+e
         7vUzfMZKHbk4sHG9WtiJnLZ3LFSMcbs0UtUkaszoMmWzlUNhy/9cntSd09pNzdeycnsC
         teCcl+RGpLbcv8PjPDf32F8LL6mlDxpTk7I1s=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] -tip/apic merging one more series
Date: Sun, 17 Aug 2008 23:41:38 +0400
Message-Id: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Simple changes mostly. The only patch which should be considered
with more attention is 

	[PATCH 9/9] x86: apic - generic_processor_info

where I suspect the bug was - we had set phys_cpu_present_map
but it could happen we warn about processor number limit after
and exit havin this bit set.

Please review - any comments are welcome!

(new week are almost started so my patch flow will decrease
 'cause of other duties)

		- Cyrill -

