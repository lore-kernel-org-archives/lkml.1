Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbXLaGBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbXLaGBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 01:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXLaGBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 01:01:08 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:33911 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956AbXLaGBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 01:01:06 -0500
Date: Mon, 31 Dec 2007 11:30:54 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Cc: dipankar@in.ibm.com, ego@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/2] Markers Implementation for RCU Tracing
Message-ID: <20071231060054.GA6416@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please accept these patches into the rt tree which convert the
existing RCU tracing mechanism for Preempt RCU and RCU Boost into
markers.
 
These patches are based upon the 2.6.24-rc5-rt1 kernel tree.
 
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
