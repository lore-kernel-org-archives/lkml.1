Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYJXUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYJXUnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbYJXUm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:42:56 -0400
Received: from waste.org ([66.93.16.53]:34052 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbYJXUm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:42:56 -0400
Subject: Bloatwatch 2.6.28-rc1: arch/x86 irq_entries_start,
	reboot_dmi_table, io_delay
From: Matt Mackall <mpm@selenic.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 15:42:31 -0500
Message-Id: <1224880951.3248.41.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86 appears to have grown 14k in my latest allnoconfig build:

http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/arch/

Most of that appears to be due to the sudden mushrooming of various dmi
tables. But the irq_entries_start table has also grown from 64 bytes to
2495 bytes:

http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/arch/x86/kernel

-- 
Mathematics is the supreme nostalgia of our time.

