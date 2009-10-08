Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbZJHJtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbZJHJtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZJHJtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:49:12 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:47774 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbZJHJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:49:10 -0400
Date: Thu, 8 Oct 2009 15:18:28 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v8 PATCH 0/8]: cpuidle: Cleanup cpuidle/ Introduce cpuidle to
	POWER.
Message-ID: <20091008094828.GA20595@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Please consider this for inclusion into the testing tree.

This patchset introduces cpuidle infrastructure to POWER, prototyping
for pSeries, and also does a major refactoring of current x86 idle
power management and a cleanup of cpuidle infrastructure.

Earlier discussions on the same can be found at:

v7 --> http://lkml.org/lkml/2009/10/6/278
v6 --> http://lkml.org/lkml/2009/9/22/180
v5 --> http://lkml.org/lkml/2009/9/22/26
v4 --> http://lkml.org/lkml/2009/9/1/133
v3 --> http://lkml.org/lkml/2009/8/27/124
v2 --> http://lkml.org/lkml/2009/8/26/233
v1 --> http://lkml.org/lkml/2009/8/19/150


Changes in this version:
--------------------------------------

* Remove redundant poll_idle definition in arch/x86/kernel/process.c

* Prevent acpi_driver from registering when boot_option_idle_override
  is set and let cpuidle_default driver to take over in this case.

* Enable default_idle when power_save=off in POWER.

thanks,
arun
