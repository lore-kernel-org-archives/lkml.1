Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbXK2UH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbXK2UH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762502AbXK2UGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:06:50 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:44699 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbXK2UGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:06:48 -0500
Date: Fri, 30 Nov 2007 01:01:10 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dipankar@in.ibm.com, ego@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/2] Markers Implementation for RCU Tracing
Message-ID: <20071129193110.GA5345@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	Please review the ensuing set of patches which convert the
existing RCU tracing mechanism for Preempt RCU and RCU Boost into
markers.

These patches are based upon the 2.6.24-rc2-rt1 kernel tree.

Along with marker transition, the RCU Tracing infrastructure has also
been modularised to be built as a kernel module, thereby enabling
runtime changes to the RCU Tracing infrastructure.

Patch [1/2] - Patch that converts the Preempt RCU tracing in
rcupreempt.c into markers.

Patch [1/2] - Patch that converts the Preempt RCU Boost tracing in
rcupreempt-boost.c into markers.

Thanks,
K.Prasad

