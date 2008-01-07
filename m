Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYAGTvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYAGTvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYAGTvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:51:13 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:55395 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbYAGTvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:51:12 -0500
Date: Tue, 8 Jan 2008 01:20:38 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Gautham R Shenoy <ego@in.ibm.com>, "K. Prasad" <prasad@linux.vnet.ibm.com>,
       mathieu.desnoyers@polymtl.ca, linux-rt-users@vger.kernel.org,
       dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/2] Markers Implementation for RCU Tracing - Ver II
Message-ID: <20080107195038.GA5119@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20071231060911.GB6461@in.ibm.com> <20080103163055.GB27651@Krystal> <20080104105858.GA13865@in.ibm.com> <20080105124632.GA16576@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105124632.GA16576@Krystal>
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
