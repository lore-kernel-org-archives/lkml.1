Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700Ab0AYEmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0AYEmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 23:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044Ab0AYEmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 23:42:11 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:60744 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab0AYEmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 23:42:11 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Warnings about tasks on CPU 1 during STR
Date: Mon, 25 Jan 2010 05:42:07 +0100
User-Agent: KMail/1.9.9
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001250542.08642.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jan 2010 04:42:09.0051 (UTC) FILETIME=[C0D82EB0:01CA9D78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.33-rc5 during suspend to RAM I'm getting a bunch of warnings
I've not seen with earlier kernel versions:

PM: late suspend of devices complete after 28.784 msecs
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
Task events/1 (pid = 10) is on cpu 1 (state = 1, flags = 84208040)
Task khelper (pid = 11) is on cpu 1 (state = 1, flags = 80208040)
Task sync_supers (pid = 77) is on cpu 1 (state = 1, flags = 80208040)
Task bdi-default (pid = 79) is on cpu 1 (state = 2, flags = 80a15040)
Task kblockd/1 (pid = 81) is on cpu 1 (state = 1, flags = 84208040)
[...]
Task pm-suspend (pid = 29782) is on cpu 1 (state = 2, flags = 414000)
Extended CMOS year: 2000
Back to C!

All the "Task X is on cpu 1" messages (76 in total) are new. Bug or
intentional? As it is a warning, I suspect a bug.

Cheers,
FJP
