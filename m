Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYFGI3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYFGI3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 04:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYFGI2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 04:28:55 -0400
Received: from [78.13.70.189] ([78.13.70.189]:47944 "EHLO linux.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754150AbYFGI2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 04:28:54 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com, menage@google.com
Cc: matt@bluehost.com, roberto@unbit.it, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cgroup: block device i/o bandwidth controller (v2)
Date: Sat,  7 Jun 2008 00:27:27 +0200
Message-Id: <1212791250-32320-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The goal of the i/o bandwidth controller is to improve i/o performance
predictability and provide better QoS for different cgroups sharing the same
block devices.

Respect to other priority/weight-based solutions the approach used by this
controller is to explicitly choke applications' requests that directly (or
indirectly) generate i/o activity in the system.

The direct bandwidth limiting method has the advantage of improving the
performance predictability at the cost of reducing, in general, the overall
performance of the system (in terms of throughput).

Detailed informations about design, its goal and usage are described in the
documentation.

Tested against latest git (2.6.26-rc5).

The all-in-one patch can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

Previous version and test report can be found here:
http://lkml.org/lkml/2008/5/24/97

Changelog since v1:
* support multiple per-block device i/o limiting rules
* minor optimizations in cgroup_io_account()
* updated the documentation and fixed some typos (thanks to Randy Dunlap for
  reviewing)

-Andrea
