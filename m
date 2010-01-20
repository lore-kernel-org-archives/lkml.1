Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175Ab0ATJWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0ATJWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700Ab0ATJV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:21:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15384 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0ATJVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:21:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 20 Jan 2010 10:11:44 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH/RFC v1 0/2] Human readable performance event description in
 sysfs
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jamie.iles@picochip.com, will.deacon@arm.com, jpihet@mvista.com,
       mingo@elte.hu, peterz@infradead.org, p.osciak@samsung.com,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com
Message-id: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While I managed to build and run the early version (back from December), I was unable to find the newest sources (infra + ARMv6, ARMv7 support).
Where do I find them?

The following patches provide a sysfs entry with hardware event human readable description in the form of "0x%llx\t%lld-%lld\t%s\t%s" % (event_value, minval, maxval, name, description) and means to populate the file.
The version posted contains ARMv6, ARMv7 (Cortex-A[89]) support in this matter.

The intended use is twofold: for users to read the list directly and for tools (like perf).

This series includes:
[PATCH v1 1/2] perfevent: Add performance event structure definition and 'extevents' sysfs entry
[PATCH v1 2/2] [ARM] perfevent: Event description list for ARMv6, Cortex-A8 and Cortex-A9 exported

Thanks,
-- 
Tomasz Fujak

