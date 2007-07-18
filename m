Return-Path: <linux-kernel-owner+w=401wt.eu-S937778AbXGRXqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937778AbXGRXqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965041AbXGRXmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:42:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:32526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbXGRXmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,553,1175497200"; 
   d="scan'208";a="107618223"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: which signal is sent to freeze process?
Date: Wed, 18 Jul 2007 16:42:02 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfJlSFnhP45UT9oQNiGdn31v0X8wg==
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jul 2007 23:42:03.0216 (UTC) FILETIME=[3E140D00:01C7C995]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My understanding is that Linux kernel sends a signal to freeze processes
during suspend2ram operation. Which signal is used to achieve this?
The problem I am facing is that some of the system calls are failing
with EINTR errno during suspend operation and I want to install a signal
handler for freeze signal with SA_RESTART flag. That should make the
kernel to retry the system calls. Right?

Thanks,
Lomesh
