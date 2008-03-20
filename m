Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYCTQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYCTQDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYCTQDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:03:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbYCTQDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:03:23 -0400
Subject: CPU siblings
From: Jon Masters <jcm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Burke <jburke@redhat.com>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Thu, 20 Mar 2008 12:03:16 -0400
Message-Id: <1206028996.5225.6.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

Myself and a colleague were just discussing the output of /proc/cpuinfo,
specifically the CPU siblings field. He pointed out/we think that this
historically was supposed to be number of HT siblings for a given CPU.

The actual value of that field comes from the Hamming Weight (number of
set bits) of the per_cpu cpu_core_map variable, which supposedly is
"representing HT and core siblings of each logical CPU", i.e. both HT
siblings and additional cores within the same CPU package.

Does this mean that "siblings" needs renaming? (doesn't it come
originally from "HT siblings"? or is it supposed to be both?). More
importantly, what's the correct way to determine number of HTs?

Jon.


