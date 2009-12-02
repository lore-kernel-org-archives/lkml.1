Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZLBJye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZLBJye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZLBJyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:54:32 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57416 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbZLBJy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:54:28 -0500
Date: Wed, 2 Dec 2009 15:24:27 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v10 PATCH 0/9] cpuidle: cleanup cpuidle/ introduce cpuidle to
 POWER
Message-ID: <20091202095427.GA27251@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset introduces cpuidle infrastructure to POWER, prototyping
for pSeries, and also does a major refactoring of current x86 idle
power management and a cleanup of cpuidle infrastructure.

This patch series has been in discussion for quite a while now and
below are the links to the previous discussions.

Please consider this for inclusion into the -tip tree.

v9 --> http://lkml.org/lkml/2009/10/16/63
v8 --> http://lkml.org/lkml/2009/10/8/82
v7 --> http://lkml.org/lkml/2009/10/6/278
v6 --> http://lkml.org/lkml/2009/9/22/180
v5 --> http://lkml.org/lkml/2009/9/22/26
v4 --> http://lkml.org/lkml/2009/9/1/133
v3 --> http://lkml.org/lkml/2009/8/27/124
v2 --> http://lkml.org/lkml/2009/8/26/233
v1 --> http://lkml.org/lkml/2009/8/19/150


Change in this version:

        Pavel noticed that the code which calls the cpuidle's idle
        loop was repeated at many places. So this set optimizes it so
        that we dont have repetition of code. The rest of the patches
        are same as the earlier iteration.


arun
