Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZKDGaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZKDGaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZKDGaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:30:05 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:53000 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZKDGaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:30:04 -0500
Date: Wed, 4 Nov 2009 12:00:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       Jan Safranek <jsafrane@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>
Subject: [RFC] Mount point suggestions for cgroup
Message-ID: <20091104063005.GC3560@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

We've been having a discussion as to what would be the right place to
mount the cgroup filesystem. Jan has been proactively looking into
this. The FHS has no recommendation since cgroup filesystem came in
much later.

The options are

1. /dev/cgroup
2. /cgroup
3. Some place under /sys

The problem with (2) is that it is quite non-standard and pollutes the
root directory. (3) requires some basic support to create a directory
for cgroup under /sys. (1) seems the most obvious choice since cpusets
were mounted under /dev/cpuset, but /dev is controlled by udev.

Given the three choices or any other suggestions, is there a general
preference as to where we can mount it? The goal is to standardize
the mount point (if possible).

BTW, the mounting is expected to be done using cgconfigparser present
in libcgroup.


-- 
	Balbir
