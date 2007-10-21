Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXJUSB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXJUSB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 14:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXJUSBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 14:01:17 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:25460 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbXJUSBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 14:01:16 -0400
X-IronPort-AV: E=Sophos;i="4.21,307,1188802800"; 
   d="scan'208";a="537950526"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Question about free/used memory on Linux
Date: Sun, 21 Oct 2007 10:54:38 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about free/used memory on Linux
Thread-Index: AcgUC3Io6vvmU09DQqCCnWOwYptTZA==
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Oct 2007 17:59:08.0541 (UTC) FILETIME=[13DC0AD0:01C8140C]
Authentication-Results: sj-dkim-3; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel gurus,
I am trying to find out the memory that's used on my linux box.
I find that there are quite a few confusing metrics. How do
I find out the "true" used memory ?

1. For eg. "free -m" shows free memory (excluding buffers/caches) 
as 308 MB while I can see(from "df" output) that the the tmpfs 
partitions take up about 400 MB. So, does "free -m" not consider 
the tmpfs partitions ?

2. I try to add up RSS field of all processes reported by
"ps aux" command. But is it true that this would be misleading
in that, shared memory used by, say 2 processes would show
up twice here although there's only one copy in memory. Also
does this consider the fact that there's only one copy
of shared libraries ?

3. I guess "free -m" and "top" commands use /proc/meminfo 
and hence all these outputs are same ?

Thanks,
Ravi
