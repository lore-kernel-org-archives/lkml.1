Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbYG3OZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbYG3OZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYG3OZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:25:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47805 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752741AbYG3OZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:25:47 -0400
Date: Wed, 30 Jul 2008 09:25:45 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: CONFIG_HOTPLUG_CPU on x86
Message-ID: <20080730142545.GA25835@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've heard folks say that hotplug cpu is very reliable.  I'm assuming
that's in the context of the x86 architecture.  If so, how come
CONFIG_HOTPLUG_CPU is still listed as EXPERIMENTAL in arch/x86/Kconfig?
Should this be changed for the x86 architecture?

config HOTPLUG_CPU
	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER

