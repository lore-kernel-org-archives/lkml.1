Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZIPInA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZIPInA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbZIPIm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:42:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:5496 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbZIPImy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:42:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="727396330"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>
Subject: [RFC][PATCH 0/10] Xen Hybrid extension support
Date: Wed, 16 Sep 2009 16:42:21 +0800
Message-Id: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Keir & Jeremy

This patchset enabled Xen Hybrid extension support.

As we know that PV guest have performance issue with x86_64 that guest kernel
and userspace resistent in the same ring, then the necessary TLB flushes when
switch between guest userspace and guest kernel cause overhead, and much more
syscall overhead is also introduced. The Hybrid Extension estimated these
overhead by putting guest kernel back in (non-root) ring0 then achieve the better
performance than PV guest.

The Hybrid Extension is started from real mode like HVM guest, but also with a
component based PV feature selection(e.g. PV halt, PV timer, event channel,
then PV drivers). So guest with Hybrid extension feature can takes the
advantages of both H/W virtualization and Para-Virtualization.

The first two of the patchset imported several header file from Jeremy's tree
and Xen tree.

The whole patchset based on Linux 2.6.30, and Xen 3.4.1.

Please give comments. Thanks!

--
regards
Yang, Sheng
