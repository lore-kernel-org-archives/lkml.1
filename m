Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZG0FaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZG0FaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZG0FaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:30:08 -0400
Received: from mga07.intel.com ([143.182.124.22]:23979 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752613AbZG0FaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,274,1246863600"; 
   d="scan'208";a="169171751"
Subject: Dynamic configure max_cstate
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Cc: yakui_zhao <yakui.zhao@intel.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 13:30:13 +0800
Message-Id: <1248672613.2560.604.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a fio workload, I found sometimes cpu C state has
big impact on the result. Mostly, fio is a disk I/O workload
which doesn't spend much time with cpu, so cpu switch to C2/C3
freqently and the latency is big.

If I start kernel with idle=poll or processor.max_cstate=1,
the result is quite good. Consider a scenario that machine is
busy at daytime and free at night. Could we add a dynamic
configuration interface for processor.max_cstate or something
similiar with sysfs? So user applications could change the
max_cstate dynamically? For example, we could add a new
parameter to function cpuidle_governor->select to mark the
highest c state.

Any idea?

Yanmin


