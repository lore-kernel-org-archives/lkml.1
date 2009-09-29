Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbZI2EGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbZI2EGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 00:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZI2EGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 00:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZI2EGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 00:06:43 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Hotplug / TSC cleanup and fixing
Date: Mon, 28 Sep 2009 18:04:28 -1000
Message-Id: <1254197072-889-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greatly simplified version of the patches; allocate and dealloc
all required structs at module load and unload time.

Clarification: per_cpu(var, cpu) does indeed work for not-present CPUs;
  the allocations for module specific per-cpu variables are done at module
  load and unload time, while the per_cpu chunks are setup for all possible
  CPUs at boot time.

