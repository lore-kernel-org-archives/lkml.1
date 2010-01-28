Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132Ab0A1Jec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0A1Jec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080Ab0A1Jea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:34:30 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57287 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0A1Je3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:34:29 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 28 Jan 2010 10:34:20 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH/RFC v2 0/3] Human readable platform-specific performance event
 support
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, peterz@infradead.org,
       p.osciak@samsung.com, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com, m.nazarewicz@samsung.com
Message-id: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Human readable description support for performance events v2. With perf support included.
Changes from v1:
 - applied on top of latest perf_event/ARM (5899/1 - 5903/1)
 - moved to debugfs, now based on seq_file
 - reads one line at a time, memory overallocation fixed [perf]

The following patches provide a sysfs entry with hardware event human readable description in the form of "0x%llx\t%lld-%lld\t%s\t%s" % (event_value, minval, maxval, name, description) and means to populate the file.
The version posted contains ARMv6, ARMv7 (Cortex-A[89]) support in this matter.

The intended use is twofold: for users to read the list directly and for tools (like perf).

This series includes:

[PATCH/RFC v2 1/3] perfevents: Added performance event structure definition, export event description in the debugfs "perf_events_platform" file
[PATCH/RFC v2 2/3] [ARM] perfevents: Event description for ARMv6, Cortex-A8 and Cortex-A9 exported
[PATCH/RFC v2 3/3] perf: Extended events (platform-specific) support in perf

Thanks,
-- 
Tomasz Fujak

