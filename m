Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbXGaKP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbXGaKP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbXGaKPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:15:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:39130 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbXGaKPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=MYfY+MXg5wH1gIeA+tP7EocjMijDmqP+/YkwB7Ih4vKuZpd5aAk9qPtOLX2f1vKbsOnyMN5k0lR88J2FsFRt997GXpr+A6YrQYtkrzBeGqqJOCxBPCRMOK9748zChn5ETeE9wyPi8Izw+4nxbil8/Qbu1G/ZtDvLBw5qQGrmgJY=
Subject: [PATCHSET 2.6.23-rc1] sysfs: locking fix and cleanups
In-Reply-To: 
X-Mailer: git-send-email
Date: Tue, 31 Jul 2007 19:15:08 +0900
Message-Id: <11858769082982-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset contains a locking fix and cleanup patches for sysfs.

#01	locking fix
#02	shadow support removal from Eric adapted to apply after #01
#03-07	clean up patches

#01 should go mainline as it fixes a locking regression introduced by
-rc1 merge.  The rest should stay in -gregkh till 24 merge window
opens up.

Clean up patches don't introduce any noticeable behavior change.  They
just refactor and simplify codes.

Thanks.

--
tejun


