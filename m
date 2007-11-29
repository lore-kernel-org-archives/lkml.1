Return-Path: <linux-kernel-owner+w=401wt.eu-S933516AbXK2TrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbXK2TrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933639AbXK2TqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:46:07 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:54793 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933636AbXK2TqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:46:06 -0500
Date: Fri, 30 Nov 2007 00:11:28 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dipankar@in.ibm.com, ego@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/2] Markers Implementation for RCU Tracing
Message-ID: <20071129184128.GA26466@in.ibm.com>
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
(prasad@linux.vnet.ibm.com)

