Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZI3VL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZI3VL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZI3VL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:11:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56138 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZI3VLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:11:55 -0400
Subject: INFO: task journal:337 blocked for more than 120 seconds
From: Shirley Ma <mashirle@us.ibm.com>
To: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 30 Sep 2009 14:11:52 -0700
Message-Id: <1254345112.8837.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Anybody found this problem before? I kept hitting this issue for 2.6.31
guest kernel even with a simple network test.

INFO: task kjournal:337 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_sec" disables this message.

kjournald	D 00000041	0	337	2 0x00000000

My test is totally being blocked.

Thanks
Shirley

