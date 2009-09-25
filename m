Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZIYAt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZIYAt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIYAt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:49:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZIYAt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:49:28 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Hotplug patches for KVM
Date: Thu, 24 Sep 2009 14:47:15 -1000
Message-Id: <1253839640-12695-1-git-send-email-zamsden@redhat.com>
In-Reply-To: <20090924151049.GB14102@amt.cnet>
References: <20090924151049.GB14102@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplified the patch series a bit and fixed some bugs noticed by Marcelo.
Axed the hot-remove notifier (was not needed), fixed a locking bug by
using cpufreq_quick_get, fixed another bug in kvm_cpu_hotplug that was
filtering out online notifications when KVM was loaded but not in use.

