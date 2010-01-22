Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094Ab0AVMJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0AVMJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 07:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450Ab0AVMJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 07:09:08 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58763 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0AVMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 07:09:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 13:08:58 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH/RFC v1 0/1] Platform-specific event support in the perf
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, peterz@infradead.org,
       p.osciak@samsung.com, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com
Message-id: <1264162139-26788-1-git-send-email-t.fujak@samsung.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The folowing patch upgrades the perf with extended performance event description, as proposed in a separate RFC.
You can find it here: http://article.gmane.org/gmane.linux.ports.arm.kernel/72822

It has been tested on a ARMv7 Cortex-A8 incarnation.
Event names can be specified to -e switch, and are reported in the list command.

The perf-predefined commands take precedence (if a collision occurs) over the platform-specific ones.
A workaround for that is though - specify the raw event, as seen provided by the system.
Currently it resides in the sysfs, but I've already been pointed to a sysfs note disclaiming mixed types, multiple lines and fancy formatting. Might swith over to debugfs.


Thanks,
-- 
Tomasz Fujak

