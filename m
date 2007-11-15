Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbXKOK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbXKOK3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbXKOK2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:28:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58238 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334AbXKOK2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:28:52 -0500
Date: Thu, 15 Nov 2007 19:30:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [0/3]
Message-Id: <20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

memory hotplug fix against 2.6.23-rc2-mm1.

Changelog
 - Divided into 3 patches
 - dropped patch against mm/sparse.c ( This was my misunderstanding.)
 - merged Andy's suggestion.

All patches are related to memory hotplug.

[1/3] ... export memory_add_physaddr_to_nid to acpi memory hotplug
[2/3] ... fix section mismatch in mm/sparse_vmemmap.c
[3/3] ... fix section mismatch in arch/x86/mm/init_64.c

Thank you for all helps.

Thanks,
-Kame

