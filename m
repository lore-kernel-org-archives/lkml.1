Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897Ab0AVDaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0AVDaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781Ab0AVDae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:30:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:13552 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669Ab0AVDad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:30:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="486039689"
Message-Id: <20100122032102.137106635@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 11:21:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, shaohui.zheng@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 0/3] generic hotplug friendly page_is_ram()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This introduces a generic iomem_resource based page_is_ram()
and removes the x86 page_is_ram().

The resource based page_is_ram() is more hotplug friendly, because memory
hotplug only updates resource and leave e820 unchanged.

The first patch changes generic code, however due to tight dependency,
I'd recommend it be included in x86 tree together with the other two.

Thanks,
Fengguang

