Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZAEUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZAEUeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZAEUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:33:56 -0500
Received: from relay3.sgi.com ([192.48.171.31]:44261 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752899AbZAEUdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:33:55 -0500
Message-Id: <20090105203351.785422000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 12:33:51 -0800
From: Mike Travis <travis@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] pci cpumask: remove local cpumask_t's from the stack
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rebased against linux-next/master (v2.6.28-rc8-5814-g8dba8f5)>

*** Note these are also in tip/cpus4096 at:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
branch: cpus4096

    588235b: cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
    3be8305: cpumask: update local_cpus_show to use new cpumask API

(Perhaps "git-pulling" them from there is a better method?)

Signed-off-by: Mike Travis <travis@sgi.com>

-- 
