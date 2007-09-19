Return-Path: <linux-kernel-owner+w=401wt.eu-S1763116AbXISSus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763116AbXISSus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXISSuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:50:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:60041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXISSuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,274,1186383600"; 
   d="scan'208";a="282395377"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: what is the difference between shutdown command and writing to /sys/power/state
Date: Wed, 19 Sep 2007 11:50:37 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628ACF018@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: what is the difference between shutdown command and writing to /sys/power/state
Thread-Index: Acf67ffjZkdeUiK0SHuSzeEPUcKCXw==
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Sep 2007 18:50:38.0270 (UTC) FILETIME=[F84345E0:01C7FAED]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does linux handles writing "disk" to /sys/power/state and shutdown -P
now differently (except writing to disk part)? I have a Xen system and
if I try both (in dom0 which is linux) then writing "disk" powers off
the system while issuing shutdown command halts the system but the
system is still power on. Dom0 is using ramdisk so writing "disk" to
/sys/power/state should essentially be same as shutdown command.
