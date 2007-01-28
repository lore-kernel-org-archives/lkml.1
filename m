Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbXA1SPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbXA1SPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 13:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXA1SPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 13:15:22 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:50794 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbXA1SPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 13:15:21 -0500
Date: Sun, 28 Jan 2007 10:09:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akuster <akuster@mvista.com>, linux-pm@lists.osdl.org
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM: fast power off - core
Message-Id: <20070128100942.edb5f7e1.randy.dunlap@oracle.com>
In-Reply-To: <45BBB097.1090207@mvista.com>
References: <45BBB097.1090207@mvista.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 10:05:43 -1000 akuster wrote:

> My apologies, I cc'd the wrong list the first time around.

{argh, attachments}

--- linux-2.6_dev.orig/kernel/power/Kconfig
+++ linux-2.6_dev/kernel/power/Kconfig
@@ -131,3 +131,5 @@ config SUSPEND_SMP
 	bool
 	depends on HOTPLUG_CPU && X86 && PM
 	default y
+
+source "kernel/power/fastoff/Kconfig"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Why a separate, new Kconfig file?
We shouldn't add a new Kconfig file for every new 1-2 kconfig symbols.


---
~Randy
